-- name: get_all_listings
-- Get all airbnb listing
SELECT
    *
FROM
    user_listings;

-- name: get_colonias_by_alcadia
-- Get colonias by alcadia
SELECT DISTINCT
    (col_name)
FROM
    listings
WHERE
    neighbourhood_cleansed_1 LIKE :delegacion ORDER BY
        1 ASC;

-- name: get_listings
-- Get all airbnb listing by values
SELECT
    *
FROM
    listings
WHERE
    mun_code = :mun_code
    AND property_type LIKE :property_type
    AND bathroom = :bathroom
    AND bedrooms = :bedrooms;

-- name: insert_listing!
-- Insert new listing
INSERT INTO user_listings (amount, colonia, bedrooms, bathroom)
    VALUES (:amount, :colonia, :bedrooms, :bathroom);

-- name: update_listing!
-- Insert new listing
UPDATE
    user_listings
SET
    amount = :amount,
    colonia = :colonia,
    bedrooms = :bedrooms,
    bathroom = :bathroom
WHERE
    id = :id;


-- name: delete_listing!
-- Insert new listing
DELETE FROM user_listings
WHERE id = :id;

