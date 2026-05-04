# Progress — Matchday LA

Updated at the end of every session. Start each new session by reading this file.

---

## Session: Week 1, Day 2 — May 4, 2026

### Completed
- [x] `npm install` (bun not available; used npm)
- [x] Set git identity (Ben / farbermc@usc.edu)
- [x] Migration 008: made `nationality` and `display_name` nullable (applied in Supabase SQL Editor)
- [x] `constants/countries.ts` — 195 countries, ISO 3166-1 alpha-2 codes, flag emoji derived at render time
- [x] `app/(protected)/onboarding/nationality.tsx` — searchable FlatList, tap-to-select with checkmark, saves ISO code to `profiles.nationality`, routes to tabs on success
- [x] `app/(protected)/_layout.tsx` — checks `profiles.nationality` on mount; redirects to onboarding if null

### In Progress
- [ ] None

### Next Session Tasks
1. **Screen 2: Match attendance selector**
   - Pull WC 2026 LA fixtures from Football-Data.org (or from `fixtures` table if pre-seeded)
   - Multi-select list of matches → inserts rows into `user_matches`
   - File: `app/(protected)/onboarding/matches.tsx`
   - After saving, route to Screen 3 (neighborhood)

2. **Get Football-Data.org API key first**: https://www.football-data.org/client/register
   - Store as `EXPO_PUBLIC_FOOTBALL_DATA_KEY` in `.env.local`
   - LA 2026 venue ID / competition ID to filter fixtures

3. **Onboarding queue remaining:**
   - Screen 3: Neighborhood input (free text + LA suggestions → `profiles.neighborhood`)
   - Screen 4: Profile photo upload (Supabase Storage) + display name

4. **Wire onboarding screens together** — after Screen 1 completes, route to Screen 2 instead of tabs

### Blockers
- None

### Decisions Made This Session
- Used `npm install` instead of bun (bun not installed on this machine)
- Nationality + display_name made nullable via migration 008; onboarding fills them progressively
- Flag emoji derived from ISO code at render time (no extra data stored)
- Onboarding redirect lives in `(protected)/_layout.tsx` — checks profile on every protected mount

### Notes
- Supabase project ref: `kxvaivaydqvetyjgshom`
- GitHub repo: `https://github.com/benthomasfarber-collab/matchday-la`
- Target: TestFlight submission by end of Week 1 (May 10, 2026)
- `package-lock.json` should be gitignored or committed — currently untracked
