--liquibase formatted sql

--changeset student:003-update-offer-friendships splitStatements:false rollbackSplitStatements:false
LOCK TABLE offer_friendship IN ACCESS EXCLUSIVE MODE;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM offer_friendship) THEN
        RAISE EXCEPTION 'Migration 003 requires an empty offer_friendship table to change id from BIGINT to UUID.';
    END IF;
END;
$$;

ALTER TABLE offer_friendship RENAME TO offer_friendships;
ALTER TABLE offer_friendships RENAME COLUMN requester_id TO from_user_id;
ALTER TABLE offer_friendships RENAME COLUMN recipient_id TO to_user_id;

ALTER TABLE offer_friendships ALTER COLUMN id DROP DEFAULT;
ALTER TABLE offer_friendships
    ALTER COLUMN id TYPE UUID USING NULL::UUID,
    ALTER COLUMN status TYPE VARCHAR(16),
    ADD COLUMN updated_at TIMESTAMPTZ NOT NULL;

--rollback LOCK TABLE offer_friendships IN ACCESS EXCLUSIVE MODE;
--rollback DO $$
--rollback BEGIN
--rollback     IF EXISTS (SELECT 1 FROM offer_friendships) THEN
--rollback         RAISE EXCEPTION 'Rollback 003 requires an empty offer_friendships table to restore BIGINT ids.';
--rollback     END IF;
--rollback END;
--rollback $$;
--rollback ALTER TABLE offer_friendships
--rollback     ALTER COLUMN id TYPE BIGINT USING NULL::BIGINT,
--rollback     ALTER COLUMN status TYPE VARCHAR(20),
--rollback     DROP COLUMN updated_at;
--rollback ALTER TABLE offer_friendships ALTER COLUMN id SET DEFAULT nextval('friend_requests_id_seq'::regclass);
--rollback ALTER TABLE offer_friendships RENAME COLUMN to_user_id TO recipient_id;
--rollback ALTER TABLE offer_friendships RENAME COLUMN from_user_id TO requester_id;
--rollback ALTER TABLE offer_friendships RENAME TO offer_friendship;
