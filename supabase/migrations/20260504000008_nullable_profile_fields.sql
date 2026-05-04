-- Onboarding fills nationality and display_name progressively;
-- both must be nullable until the user completes the flow.
ALTER TABLE profiles ALTER COLUMN nationality DROP NOT NULL;
ALTER TABLE profiles ALTER COLUMN display_name DROP NOT NULL;
