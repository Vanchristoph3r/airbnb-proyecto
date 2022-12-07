-- name: get_all_listings
-- Get all airbnb listing
SELECT
    id,
    nombre
FROM
    listings;

-- name: get_colonias_by_alcadia
-- Get colonias by alcadia
SELECT
    distinct(col_name)
FROM
    listings
WHERE
    neighbourhood_cleansed_1 like :delegacion ;


-- name: get_listings
-- Get all airbnb listing by values
SELECT
    *
FROM
    listings
WHERE
    mun_code = :mun_code AND 
    property_type like :property_type AND 
    bathroom = :bathroom AND 
    bedrooms = :bedrooms;


-- name: insert_listing!
-- Insert new listing
INSERT INTO listing (name)
    VALUES (:name);

-- name: update_listing!
-- Insert new listing
UPDATE
    listing
SET
    name = :name
WHERE
    id = :id;


-- name: delete_listing!
-- Insert new listing
DELETE FROM listing
WHERE id = :id;


