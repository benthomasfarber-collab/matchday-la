# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

---

# Matchday LA — Project Context

## Stack
- **Mobile app**: Expo (React Native) with Expo Router — file-based routing
- **Backend / Auth / DB**: Supabase — auth, real-time, storage, PostgreSQL
- **Push notifications**: Expo Push Notifications
- **Match data**: Football-Data.org API (free tier, 10 req/min)
- **AI**: Claude API (`claude-sonnet-4-6`) — vision analysis, push copy generation
- **Payments**: Stripe Checkout (Phase 2 events) + Stripe Connect (Phase 2 marketplace, deferred)

## Project Structure
```
matchday-la/
├── CLAUDE.md                    ← this file
├── PROGRESS.md                  ← end-of-session checkpoint
├── docs/
│   ├── DECISIONS.md             ← architectural decisions (do not revisit)
│   └── SPEC.md                  ← full product specification
├── app/
│   ├── (auth)/                  ← sign up / sign in screens
│   ├── (tabs)/                  ← main tab navigation
│   │   ├── discover/            ← browse fans by nationality/match
│   │   ├── matches/             ← match schedule + groups
│   │   ├── events/              ← watch party events
│   │   └── profile/             ← user profile
│   └── chat/                    ← DMs + group chat
├── components/
├── hooks/
├── lib/
│   └── supabase.ts
├── providers/
│   └── supabase-provider.tsx
└── supabase/
    ├── migrations/              ← sequential SQL migration files
    └── functions/               ← Edge Functions (push triggers, polling, Claude Vision)
```

## Current State (Week 1, Day 1)
- [x] Repo scaffolded from expo-supabase-starter (Supabase version)
- [x] CLAUDE.md initialized
- [x] DECISIONS.md initialized
- [x] 7 Supabase migration files generated
- [ ] Onboarding flow (next task)
- [ ] Auth (email + Google OAuth)
- [ ] Profile screen

## Active Task
**Onboarding flow** — build one screen per session:
1. Screen 1: Nationality picker (flag emoji + country name, searchable, ISO code stored)
2. Screen 2: Match attendance selector (pull LA fixtures from Football-Data.org, multi-select)
3. Screen 3: Neighborhood input (free text + LA neighborhood suggestions)
4. Screen 4: Profile photo upload (Supabase Storage) + display name

## Key Conventions
- **TEXT + CHECK constraints, not ENUMs** — all status fields use TEXT with CHECK constraints
- **Real-time via Supabase subscriptions** — use `supabase.channel()`, never poll in the mobile app
- **Edge Functions for all async work** — Claude Vision, push sends, match result polling
- **Commit after each discrete task** — every screen, every migration, every feature
- **One task per session** — start specific, finish it, commit, close

## Do Not (Decisions Already Made — Do Not Re-Litigate)
- **No Redux or Zustand** — Supabase client + React Context only; add state management only if a specific need emerges
- **No Stripe Connect at launch** — KYC latency too long; free events only at launch; paid ticketing via simpler Stripe Checkout in Phase 2
- **No polling in mobile app** — all real-time via Supabase subscriptions
- **Never block photo upload on Claude Vision** — async only; show "Analyzing vibe..." placeholder
- **Push budget: max 3 per user per match day** — hard limit, no exceptions
- **Football-Data.org polling only during match windows** — kickoff through full time + 30min, not 24/7
- **Never trigger the same deal twice** — check `deals.triggered_at IS NULL` before firing
