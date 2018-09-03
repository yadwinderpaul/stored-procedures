CREATE OR REPLACE FUNCTION get_schedules(
  store_id TEXT,
  area_id TEXT,
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
DECLARE
  doffset BIGINT := 0;
BEGIN
  SELECT delivery_offset
  INTO doffset
  FROM service.areas
  WHERE id::TEXT = area_id;

  RETURN QUERY
    SELECT
      results.pickup_start,
      results.pickup_stop,
      results.delivery_start + doffset AS delivery_start,
      results.delivery_stop + doffset AS delivery_stop,
      results.pickup_interval,
      format_interval(
        results.delivery_start + doffset, results.delivery_stop + doffset
      ) AS delivery_interval
    FROM get_schedules(store_id, input_ts) AS results;
END; $$
LANGUAGE PLPGSQL;
