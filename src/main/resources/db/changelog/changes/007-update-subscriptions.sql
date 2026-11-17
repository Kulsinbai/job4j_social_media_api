--liquibase formatted sql

--changeset student:007-update-subscriptions rollbackSplitStatements:false
ALTER TABLE subscriptions RENAME COLUMN subscriber_id TO follower_id;
ALTER TABLE subscriptions RENAME COLUMN target_id TO followed_id;

ALTER TABLE subscriptions
    DROP CONSTRAINT subscriptions_pkey,
    ADD COLUMN id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    ADD CONSTRAINT uq_subscription_users UNIQUE (follower_id, followed_id);

ALTER TABLE subscriptions ALTER COLUMN id DROP DEFAULT;

--rollback LOCK TABLE subscriptions IN ACCESS EXCLUSIVE MODE;
--rollback DO $$
--rollback BEGIN
--rollback     IF EXISTS (SELECT 1 FROM subscriptions) THEN
--rollback         RAISE EXCEPTION 'Rollback 007 requires an empty subscriptions table to remove UUID ids.';
--rollback     END IF;
--rollback END;
--rollback $$;
--rollback ALTER TABLE subscriptions
--rollback     DROP CONSTRAINT uq_subscription_users,
--rollback     DROP CONSTRAINT subscriptions_pkey,
--rollback     DROP COLUMN id;
--rollback ALTER TABLE subscriptions RENAME COLUMN followed_id TO target_id;
--rollback ALTER TABLE subscriptions RENAME COLUMN follower_id TO subscriber_id;
--rollback ALTER TABLE subscriptions ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (subscriber_id, target_id);
