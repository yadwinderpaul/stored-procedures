CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS citext;

----
-- create schemas
----
CREATE SCHEMA IF NOT EXISTS admin;
CREATE SCHEMA IF NOT EXISTS service;

----
-- create areas table
----
CREATE TABLE IF NOT EXISTS service.areas (
  id uuid PRIMARY KEY default uuid_generate_v1mc(),
  area_name text,
  area_geometry text /*This would be of type geometry for PostGIS*/
);

----
-- create stores table
----
CREATE TABLE IF NOT EXISTS admin.vendor_stores (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v1mc(),
  store_name text,
  store_email citext
);

----
-- create store working hours table
----
CREATE TABLE IF NOT EXISTS admin.vendor_store_work_hours (
  retailer_id uuid references admin.vendor_stores(id),
  day_of_week integer,
  working_start_window_hours integer,
  working_start_window_minutes integer,
  working_stop_window_hours integer,
  working_stop_window_minutes integer
);

----
-- create delivery schedules and prices table
----
CREATE TABLE IF NOT EXISTS service.schedules_and_prices (
  retailer_id uuid references admin.vendor_stores(id),
  day_of_week integer,
  delivery_start_window_hours integer,
  delivery_start_window_minutes integer,
  delivery_stop_window_hours integer,
  delivery_stop_window_minutes integer,
  price double precision default 59.0,
  price_currency text default 'SEK'
);
