-- Run this ONLY if you already imported the older ShoeSystem database.
-- Back up your database first. Existing date_added values will be set to the
-- migration time because the previous schema did not store the original date.

USE shoe_store;

ALTER TABLE brands
    ADD COLUMN date_added TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN last_updated_by INT NULL;

ALTER TABLE shoes
    ADD COLUMN date_added TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN last_updated_by INT NULL;

-- Preserve the old updated_by values under the required column name.
UPDATE brands SET last_updated_by = updated_by WHERE updated_by IS NOT NULL;
UPDATE shoes SET last_updated_by = updated_by WHERE updated_by IS NOT NULL;

ALTER TABLE brands
    ADD CONSTRAINT fk_brands_last_updated_by
    FOREIGN KEY (last_updated_by) REFERENCES users(user_id) ON DELETE RESTRICT;

ALTER TABLE shoes
    ADD CONSTRAINT fk_shoes_last_updated_by
    FOREIGN KEY (last_updated_by) REFERENCES users(user_id) ON DELETE RESTRICT;

ALTER TABLE brands DROP COLUMN updated_by;
ALTER TABLE shoes DROP COLUMN updated_by;
