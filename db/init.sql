
CREATE DATABASE airbnb;
CREATE USER airbnb_user;

GRANT ALL PRIVILEGES ON DATABASE airbnb TO airbnb_user;



\c airbnb

CREATE TABLE IF NOT EXISTS listings (
    id serial PRIMARY KEY,
    id_raw text,
    host_response_time text,
    host_response_rate real,
    host_acceptance_rate real,
    host_is_superhost integer,
    host_has_profile_pic integer,
    host_identity_verified integer,
    NEIGHBOURHOOD_CLEANSED_1 text,
    latitude real,
    longitude real,
    property_type text,
    room_type text,
    accommodates integer,
    bathroom real,
    bathrooms_text text,
    bedrooms integer,
    beds integer,
    price numeric,
    instant_bookable integer,
    sta_code integer,
    sta_name text,
    mun_code integer,
    mun_name text,
    col_code text,
    col_name text,
    col_area_co text,
    col_type text
);

CREATE TABLE IF NOT EXISTS crime_reports (
    id serial PRIMARY KEY,
    field_1 integer,
    ao_hechos integer,
    mes_hechos text,
    fecha_hechos text,
    ao_inicio integer,
    mes_inicio text,
    fecha_inicio text,
    delito text,
    fiscalia text,
    agencia text,
    unidad_investigacion text,
    categoria_delito text,
    calle_hechos text,
    calle_hechos2 text,
    colonia_hechos text,
    alcaldia_hechos text,
    longitud real,
    latitud real,
    tempo real,
    year integer,
    sta_code integer,
    sta_name text,
    mun_code integer,
    mun_name text,
    col_code text,
    col_name text,
    col_area_co text,
    col_type text
);

CREATE TABLE user_listings(
    user_id integer,
    amount real,
    listing jsonb
);


GRANT ALL PRIVILEGES ON TABLE listings TO airbnb_user;
GRANT ALL PRIVILEGES ON TABLE crime_reports TO airbnb_user;
GRANT ALL PRIVILEGES ON TABLE user_listings TO airbnb_user;


COPY listings (id_raw, host_response_time, host_response_rate, host_acceptance_rate, host_is_superhost, host_has_profile_pic, host_identity_verified, NEIGHBOURHOOD_CLEANSED_1, latitude, longitude, property_type, room_type, accommodates, bathroom, bathrooms_text, bedrooms, beds, price, instant_bookable, sta_code, sta_name, mun_code, mun_name, col_code, col_name, col_area_co, col_type)
FROM
    '/db/listings_cdmx_updated.csv' DELIMITER ',' CSV HEADER NULL AS 'NA';

COPY crime_reports (field_1, ao_hechos, mes_hechos, fecha_hechos, ao_inicio, mes_inicio, fecha_inicio, delito, fiscalia, agencia, unidad_investigacion, categoria_delito, calle_hechos, calle_hechos2, colonia_hechos, alcaldia_hechos, longitud, latitud, tempo, year, sta_code, sta_name, mun_code, mun_name, col_code, col_name, col_area_co, col_type)
FROM
    '/db/carpeta.csv' DELIMITER ',' CSV HEADER NULL AS 'NA';

