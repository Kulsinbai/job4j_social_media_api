--liquibase formatted sql

--changeset student:002-rename-friend-request

ALTER TABLE friend_requests
    RENAME TO offer_friendship;

--rollback ALTER TABLE offer_friendship RENAME TO friend_requests;