-- ============================================================
-- MIGRATION 006: events
-- ============================================================
CREATE TABLE events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  creator_id UUID REFERENCES profiles(id),
  fixture_id TEXT,
  title TEXT NOT NULL,
  description TEXT,
  location TEXT NOT NULL,
  starts_at TIMESTAMPTZ NOT NULL,
  is_free BOOLEAN DEFAULT true,
  max_attendees INTEGER,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE event_rsvps (
  event_id UUID REFERENCES events(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  rsvp_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (event_id, user_id)
);

ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_rsvps ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Events visible to all authenticated users"
  ON events FOR SELECT TO authenticated USING (true);

CREATE POLICY "Users create events"
  ON events FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = creator_id);

CREATE POLICY "Users manage own RSVPs"
  ON event_rsvps FOR ALL TO authenticated
  USING (auth.uid() = user_id);

-- Enable real-time
ALTER PUBLICATION supabase_realtime ADD TABLE event_rsvps;
