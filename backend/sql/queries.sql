-- name: get_all_listings
-- Get all airbnb listing
SELECT
    id,
    nombre
FROM
    listings;

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

-- name: get_carpet
-- Get all gastations
SELECT
    *
FROM
    crime_reports;

-- name: insert_listing!
-- Insert new listing
INSERT INTO listing (name)
    VALUES (:name);

-- name: insert_crimes!
-- Insert new price
INSERT INTO crime_reports (name)
    VALUES (:name);

-- name: update_listing!
-- Insert new listing
UPDATE
    listing
SET
    name = :name
WHERE
    id = :id;

-- name: update_crimes!
-- Insert new price
UPDATE
    crime_reports
SET
    name = :name
WHERE
    id = :id;

-- name: delete_listing!
-- Insert new listing
DELETE FROM listing
WHERE id = :id;

-- name: delete_crimes!
-- Insert new price
DELETE FROM crime_reports
WHERE id = :id;

