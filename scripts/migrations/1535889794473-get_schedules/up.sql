CREATE OR REPLACE FUNCTION get_schedules(
  store_id TEXT,
  input_ts TIMESTAMP
)
  RETURNS TABLE(
    pickup_start DOUBLE PRECISION,
    pickup_stop DOUBLE PRECISION,
    delivery_start DOUBLE PRECISION,
    delivery_stop DOUBLE PRECISION,
    pickup_interval TEXT,
    delivery_interval TEXT
  ) AS $$
BEGIN
  RETURN QUERY
    SELECT
      pstart AS pickup_start,
      pstop AS pickup_stop,
      dstart AS delivery_start,
      dstop AS delivery_stop,
      format_interval(pstart, pstop) AS pickup_interval,
      format_interval(dstart, dstop) AS delivery_interval
    FROM (
      SELECT DISTINCT ON (dates.value)
  			EXTRACT(epoch FROM dates.value) + (
  				wh.working_start_window_hours * 60 +
  				wh.working_start_window_minutes
  		  ) * 60 AS pstart,
  		  EXTRACT(epoch FROM dates.value) + (
  				wh.working_stop_window_hours * 60 +
  				wh.working_stop_window_minutes
  		  ) * 60 AS pstop,
  		  EXTRACT(epoch FROM dates.value) + (
  				sp.delivery_start_window_hours * 60 +
  				sp.delivery_start_window_minutes
  		  ) * 60 AS dstart,
  		  EXTRACT(epoch FROM dates.value) + (
  				sp.delivery_stop_window_hours * 60 +
  				sp.delivery_stop_window_minutes
  		  ) * 60 AS dstop
  		FROM admin.vendor_stores s
  		INNER JOIN admin.vendor_store_work_hours wh
  		ON s.id = wh.retailer_id
  		INNER JOIN service.schedules_and_prices sp
  		ON s.id = sp.retailer_id and wh.day_of_week = sp.day_of_week
      INNER JOIN (
  			SELECT d::TIMESTAMP AS value
        FROM generate_series(
          input_ts, input_ts + interval '6 days', interval '1 day'
        ) d
  		) dates
  		ON sp.day_of_week = EXTRACT(dow FROM dates.value)
      WHERE s.id::TEXT = store_id
      ORDER BY dates.value ASC
    ) AS results;
END; $$
LANGUAGE PLPGSQL;
