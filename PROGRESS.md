# Progress — Matchday LA

Updated at the end of every session. Start each new session by reading this file.

---

## Session: Week 1, Day 1 — May 4, 2026

### Completed
- [x] Cloned `FlemingVincent/expo-supabase-starter` at last Supabase commit (pre-Clerk migration)
- [x] Removed upstream origin, renamed app to `matchday-la` in app.json
- [x] Merged Karpathy CLAUDE.md behavior rules; appended Matchday LA project context
- [x] Created `docs/DECISIONS.md` (14 architectural decisions with rationale)
- [x] Created `docs/SPEC.md` (full product specification)
- [x] Created `supabase/migrations/` with all 7 community layer SQL migrations
- [x] Created `.env.local.example` with all required env var keys

### In Progress
- [ ] None

### Next Session Tasks
1. **User must do first:**
   - Create a GitHub repo named `matchday-la`, then run:
     ```bash
     git remote add origin https://github.com/[username]/matchday-la.git
     git push -u origin main
     ```
   - Create a Supabase project at supabase.com
   - Apply the 7 migrations (SQL Editor in Supabase dashboard, run in order 001–007)
   - Copy `.env.local.example` to `.env.local` and fill in Supabase URL + anon key

2. **Then start onboarding flow — one screen per session:**
   - Screen 1: Nationality picker
     - Searchable list with flag emoji + country name
     - Stores ISO 3166-1 alpha-2 code (e.g., 'BR', 'US', 'MX')
     - Saves to `profiles.nationality`
   - Screen 2: Match attendance selector
     - Fetch LA fixtures from Football-Data.org (competition WC, season 2026)
     - Multi-select, store in `user_matches` table
   - Screen 3: Neighborhood input
     - Free text + suggestions: Hollywood, Santa Monica, Downtown LA, Inglewood, etc.
     - Saves to `profiles.neighborhood`
   - Screen 4: Profile photo + display name
     - Photo upload to Supabase Storage
     - Saves `avatar_url` and `display_name` to profiles

### Blockers
- GitHub remote not yet set up (user action required)
- Supabase project not yet created (user action required)
- Migrations not yet applied (user action required after Supabase project exists)

### Decisions Made This Session
- Used last Supabase-era commit of expo-supabase-starter (commit `3763506`) — the repo was
  since migrated to Clerk+Convex, but we need Supabase
- Added `fixtures` table to Migration 002 (not in original spec) to cache Football-Data.org
  data locally and avoid live API calls during onboarding

### Notes
- git identity not set — run `git config --global user.name "Ben"` and
  `git config --global user.email "farbermc@usc.edu"` to clean up commit attribution
