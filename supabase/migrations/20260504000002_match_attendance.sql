-- ============================================================
-- MIGRATION 002: match attendance
-- ============================================================
CREATE TABLE user_matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  fixture_id TEXT NOT NULL,            -- Football-Data.org fixture ID
  match_date DATE NOT NULL,
  teams TEXT NOT NULL,                 -- 'USA vs Paraguay' — denormalized for speed
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, fixture_id)
);

ALTER TABLE user_matches ENABLE ROW LEVEL SECURITY;

CREATE POLICY "User matches readable by authenticated users"
  ON user_matches FOR SELECT TO authenticated USING (true);

CREATE POLICY "Users manage own match attendance"
  ON user_matches FOR ALL TO authenticated
  USING (auth.uid() = user_id);

-- ============================================================
-- Fixtures cache table (populated at build time from Football-Data.org)
-- ============================================================
CREATE TABLE fixtures (
  id TEXT PRIMARY KEY,                 -- Football-Data.org fixture ID
  match_date DATE NOT NULL,
  kickoff_time TIMESTAMPTZ,
  home_team TEXT NOT NULL,
  away_team TEXT NOT NULL,
  venue TEXT,
  stage TEXT,                          -- 'Group Stage', 'Round of 32', etc.
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE fixtures ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Fixtures readable by authenticated users"
  ON fixtures FOR SELECT TO authenticated USING (true);
