-- ============================================================
-- MIGRATION 005: match groups
-- ============================================================
CREATE TABLE match_groups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fixture_id TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  creator_id UUID REFERENCES profiles(id),
  meet_location TEXT,
  max_members INTEGER DEFAULT 20,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE group_members (
  group_id UUID REFERENCES match_groups(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (group_id, user_id)
);

CREATE TABLE group_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID REFERENCES match_groups(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES profiles(id),
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE match_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Groups visible to all authenticated users"
  ON match_groups FOR SELECT TO authenticated USING (true);

CREATE POLICY "Members see group messages"
  ON group_messages FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM group_members
      WHERE group_id = group_messages.group_id
      AND user_id = auth.uid()
    )
  );

CREATE POLICY "Members send group messages"
  ON group_messages FOR INSERT TO authenticated
  WITH CHECK (
    auth.uid() = sender_id AND
    EXISTS (
      SELECT 1 FROM group_members
      WHERE group_id = group_messages.group_id
      AND user_id = auth.uid()
    )
  );

-- Enable real-time
ALTER PUBLICATION supabase_realtime ADD TABLE group_messages;
