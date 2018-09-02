CREATE OR REPLACE FUNCTION get_schedules(input_epoch NUMERIC)
  RETURNS TABLE(
    day_of_week INT,
    pickup_start NUMERIC,
    pickup_stop NUMERIC,
    delivery_start NUMERIC,
    delivery_stop NUMERIC
  ) AS $$
BEGIN
  RETURN QUERY
		SELECT DISTINCT on (day_of_week)
		  wh.day_of_week as day_of_week,
			input_epoch + (
				wh.working_start_window_hours * 60 +
				wh.working_start_window_minutes
		  ) * 60 * 1000 as pickup_start,
		  input_epoch + (
				wh.working_stop_window_hours * 60 +
				wh.working_stop_window_minutes
		  ) * 60 * 1000 as pickup_stop,
		  input_epoch + (
				sp.delivery_start_window_hours * 60 +
				sp.delivery_start_window_minutes
		  ) * 60 * 1000 as delivery_start,
		  input_epoch + (
				sp.delivery_stop_window_hours * 60 +
				sp.delivery_stop_window_minutes
		  ) * 60 * 1000 as delivery_stop
		FROM admin.vendor_stores s
		INNER JOIN admin.vendor_store_work_hours wh
		ON s.id = wh.retailer_id
		INNER JOIN service.schedules_and_prices sp
		ON s.id = sp.retailer_id and wh.day_of_week = sp.day_of_week;
END; $$
LANGUAGE PLPGSQL;
