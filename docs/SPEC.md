# Matchday LA — Claude Code Build Plan
**Solo Build | Community-First | 6 Weeks to Soft Launch | Today: May 4, 2026**

---

## What We're Building

A World Cup 2026 fan app targeting international tourists visiting Los Angeles
(June 11 – July 19, 2026). One app, two eventual layers — but we are building
the community layer only first, launching it, getting tourists using it, and
adding monetization after we have a user base.

**Launch target: May 25, 2026 (soft launch, community layer only)**
**Tournament start: June 11, 2026**

### Two Audiences
- **Tourists**: international fans in LA who want to connect with other fans,
  find locals, and coordinate around matches
- **Local businesses** (Phase 2 only): restaurants, bars, venues that want to
  reach World Cup tourists with targeted promotions

### Phase 1 — Community Layer (Weeks 1–3, ship May 25)
- User onboarding: nationality, matches attending, neighborhood staying in
- Fan browse and matching: find fans by nationality, shared match, neighborhood
- Direct messaging (Supabase real-time)
- Match groups: create/join groups for specific fixtures, group chat,
  meet-up coordination
- Watch party events: free RSVP-only events (no paid ticketing at launch)
- Push notifications: new messages, event reminders

### Phase 2 — Venue/Deals Layer (Weeks 4–6, ship before June 11)
- Business dashboard (Next.js): photo posting, deal creation, analytics
- Tourist venue feed: real-time photo feed, Claude Vision vibe tagging,
  proximity + vibe filtering
- Conditional deal engine: match result triggers automated deal activation
- Targeted push notification campaigns
- Paid event ticketing (Stripe Checkout, simpler than Connect)
- Peer services marketplace (Stripe Connect) — stub only, full launch TBD

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile app | Expo (React Native) — iOS + Android |
| Business dashboard | Next.js (Phase 2) |
| Backend / Database | Supabase — auth, real-time, storage, PostgreSQL |
| Push notifications | Expo Push Notifications |
| Match data | Football-Data.org API (free tier) |
| AI | Claude API (claude-sonnet-4-6) — vision, push copy, personalization |
| Payments | Stripe Checkout (Phase 2 events) + Stripe Connect (Phase 2 marketplace) |
| Hosting | Vercel (Next.js) + Supabase cloud |

---

## Supabase Schema

Apply as sequential migrations. Community layer only.

```sql
-- ============================================================
-- MIGRATION 001: profiles
-- ============================================================
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  display_name TEXT NOT NULL,
  bio TEXT,
  avatar_url TEXT,
  nationality TEXT NOT NULL,
  neighborhood TEXT,
  language_preference TEXT DEFAULT 'en',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ... (see supabase/migrations/ for full SQL)
```

---

## LA World Cup Fixtures Reference

Call `https://api.football-data.org/v4/competitions/WC/matches?season=2026`
with header `X-Auth-Token: YOUR_KEY` to get the full fixture list at build time.
Store fixture data in a `fixtures` table so onboarding doesn't require a live API call.

---

## Architectural Decisions

See `docs/DECISIONS.md` for the full list. Do not re-litigate.

---

## Week-by-Week Task Breakdown

### WEEK 1 (May 4–10) — Foundation
**Goal: Running app with auth and profiles in TestFlight**

1. Clone starter, set up project
2. Merge Karpathy CLAUDE.md, install tooling
3. Generate CLAUDE.md and DECISIONS.md from this spec
4. Set up environment variables
5. Apply all 7 migrations to Supabase
6. Build onboarding flow (4 screens, one per session)
7. Auth: email sign-up/sign-in + Google OAuth
8. Profile screen: view + edit
9. Submit to TestFlight

### WEEK 2 (May 11–17) — Fan Matching + Messaging
**Goal: Tourists can find each other and talk**

1. Fan browse screen with filter chips
2. Profile detail screen + connect button
3. Connection flow (send/accept/decline)
4. DM thread list
5. DM conversation screen (real-time)
6. Push notifications for new DMs

### WEEK 3 (May 18–24) — Groups + Events + Launch
**Goal: Community layer complete, soft launch May 25**

1. Match groups browse
2. Create group screen
3. Group detail + group chat (real-time)
4. Events list + create event + event detail
5. Event reminder push notifications
6. App polish
7. App Store submission
8. May 25: Soft launch seeding

### WEEK 4 (May 25–31) — Stabilize + B2B Groundwork
1. Monitor crashes (Sentry)
2. Fix auth edge cases
3. Performance optimizations
4. Pre-seed match groups
5. B2B outreach begin
6. Stub Phase 2 schema (migrations only)

### WEEK 5 (June 1–7) — Venue Feed
1. Business dashboard (Next.js, Vercel)
2. Claude Vision Edge Function (async vibe tagging)
3. Tourist venue feed (real-time, vibe filters)

### WEEK 6 (June 8–11) — Deal Engine + Final Polish
1. Football-Data.org match polling Edge Function
2. Conditional deal activation
3. Claude-generated push copy
4. Paid events (Stripe Checkout)
5. End-to-end pipeline test
6. Final App Store submission

---

## Key Technical Challenges

### Stripe Connect Onboarding Latency
Do NOT build for the 6-week window. Use Stripe Checkout for paid events only.

### Claude Vision Pipeline — Must Be Async
Photo upload → immediate success → Edge Function triggers async → vibe tags appear 10–30s later.

### Match Result Polling — Rate Limits
Football-Data.org free tier: 10 req/min. Only poll during match windows. Store `last_polled_at`.

### Push Notification Timing
Post-match window is ~15 minutes of peak intent. Deal trigger → Claude copy → Expo Push < 60s.

### Real-Time Connection Limits
Supabase free tier: 200 concurrent WebSocket connections. Alert at 150.

### Cold Start on Groups
Pre-seed 4–5 groups per LA fixture before soft launch.

---

## Launch Strategy

### May 25 Soft Launch — Community Layer
Post authentically in:
- r/worldcup, r/LosAngeles, r/brasil, r/ussoccer, r/mexico, r/belgiereddevils, r/USMNT
- Facebook groups: national team supporters clubs with LA travel threads
- Twitter/X: #FIFAWorldCup2026 #WorldCup2026LA #USMNT

Lead with the fan matching angle. Screenshot the nationality browse screen with multiple flags.

### Week 4 B2B Outreach
Target bars/restaurants within 2 miles of SoFi Stadium, Inglewood CA.
First 10 venues get a free first campaign.

---

## Monetization Hooks (Stub From Day 1, Build Phase 2)

| Revenue Stream | Model | Status |
|---------------|-------|--------|
| Peer services commission | 18% via Stripe Connect | Phase 2 |
| Event ticketing | 15% via Stripe Checkout | Week 6 |
| Business event sponsorships | $300–800 flat per event | Manual/invoice |
| Deal push campaigns | $75–200 per match-day campaign | Week 6 |
| Business monthly subscription | $400–800/month | Post-tournament |

---

## App Store Metadata (Prepare Week 3)

**App Name:** Matchday LA
**Subtitle:** World Cup Fan Community
**Categories:** Primary: Social Networking | Secondary: Sports
**Age Rating:** 4+
**Keywords:** world cup 2026, soccer fans LA, FIFA 2026, football fans Los Angeles, SoFi stadium, fan meetup, international soccer

---

## Environment Variables

```bash
# Supabase
EXPO_PUBLIC_SUPABASE_URL=https://[project-ref].supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=[anon-key]
SUPABASE_SERVICE_ROLE_KEY=[service-role-key]  # Edge Functions only

# Football-Data.org
FOOTBALL_DATA_API_KEY=[your-key]

# Claude API (Edge Functions)
ANTHROPIC_API_KEY=[your-key]

# Stripe (Phase 2)
STRIPE_SECRET_KEY=[your-key]
STRIPE_WEBHOOK_SECRET=[your-webhook-secret]
EXPO_PUBLIC_STRIPE_PUBLISHABLE_KEY=[your-publishable-key]
```
