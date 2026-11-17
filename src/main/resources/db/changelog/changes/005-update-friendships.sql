--liquibase formatted sql

--changeset student:005-update-friendships splitStatements:false rollbackSplitStatements:false
LOCK TABLE friendships IN ACCESS EXCLUSIVE MODE;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM friendships) THEN
        RAISE EXCEPTION 'Migration 005 requires an empty friendships table to add the required offer_friendship_id.';
    END IF;
END;
$$;

ALTER TABLE friendships RENAME COLUMN user_id TO first_user_id;
ALTER TABLE friendships RENAME COLUMN friend_id TO second_user_id;

ALTER TABLE friendships
    DROP CONSTRAINT friendships_pkey,
    DROP CONSTRAINT chk_friendship_users,
    ADD COLUMN id UUID PRIMARY KEY,
    ADD COLUMN offer_friendship_id UUID NOT NULL,
    ADD CONSTRAINT uq_friendship_users UNIQUE (first_user_id, second_user_id),
    ADD CONSTRAINT chk_friendship_users CHECK (first_user_id < second_user_id),
    ADD CONSTRAINT fk_friendship_offer FOREIGN KEY (offer_friendship_id) REFERENCES offer_friendships (id);

--rollback LOCK TABLE friendships IN ACCESS EXCLUSIVE MODE;
--rollback DO $$
--rollback BEGIN
--rollback     IF EXISTS (SELECT 1 FROM friendships) THEN
--rollback         RAISE EXCEPTION 'Rollback 005 requires an empty friendships table to remove id and offer_friendship_id.';
--rollback     END IF;
--rollback END;
--rollback $$;
--rollback ALTER TABLE friendships
--rollback     DROP CONSTRAINT fk_friendship_offer,
--rollback     DROP CONSTRAINT chk_friendship_users,
--rollback     DROP CONSTRAINT uq_friendship_users,
--rollback     DROP CONSTRAINT friendships_pkey,
--rollback     DROP COLUMN offer_friendship_id,
--rollback     DROP COLUMN id;
--rollback ALTER TABLE friendships RENAME COLUMN second_user_id TO friend_id;
--rollback ALTER TABLE friendships RENAME COLUMN first_user_id TO user_id;
--rollback ALTER TABLE friendships
--rollback     ADD CONSTRAINT friendships_pkey PRIMARY KEY (user_id, friend_id),
--rollback     ADD CONSTRAINT chk_friendship_users CHECK (user_id <> friend_id);
