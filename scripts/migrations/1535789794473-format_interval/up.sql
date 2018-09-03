CREATE OR REPLACE FUNCTION format_interval(
  start DOUBLE PRECISION,
  stop DOUBLE PRECISION
)
  RETURNS TEXT
AS $$
BEGIN
  RETURN
    to_char(to_timestamp(start), 'MON DD HH12:MI AM')::TEXT ||
    ' - ' ||
    to_char(to_timestamp(stop), 'HH12:MI AM')::TEXT;
END; $$
LANGUAGE PLPGSQL;
