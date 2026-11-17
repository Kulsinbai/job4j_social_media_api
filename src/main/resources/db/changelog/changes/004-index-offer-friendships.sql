--liquibase formatted sql

--changeset student:004-index-offer-friendships
CREATE INDEX idx_offer_friendships_to_user_status_created
    ON offer_friendships (to_user_id, status, created_at DESC);

CREATE INDEX idx_offer_friendships_from_user_status_created
    ON offer_friendships (from_user_id, status, created_at DESC);

--rollback DROP INDEX idx_offer_friendships_from_user_status_created;
--rollback DROP INDEX idx_offer_friendships_to_user_status_created;
