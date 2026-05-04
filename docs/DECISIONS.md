# Architectural Decisions

These decisions are final. Do not re-litigate them without an extraordinary reason.
Each entry includes the decision and a one-line rationale.

---

## Payments

**1. No Stripe Connect at launch.**
KYC identity verification takes days to weeks — incompatible with the 6-week build window.

**2. Free events only at launch; paid ticketing via Stripe Checkout in Phase 2.**
Stripe Checkout requires no Connect account — simpler, faster to ship.

**3. Peer services marketplace (Stripe Connect) deferred entirely.**
Full Connect onboarding is a separate product surface; stub only for now.

---

## Database Schema

**4. TEXT + CHECK constraints, not ENUMs.**
Easier to extend status fields without write-blocking schema migrations.
Applied to: `connections.status` ('pending'|'accepted'|'declined'), `push_tokens.platform` ('ios'|'android').

---

## Backend Architecture

**5. Supabase Edge Functions for all async work.**
Claude Vision pipeline, push notification sends, match result polling — all in Edge Functions.
The mobile app stays thin and stateless.

**6. Football-Data.org polling is time-gated.**
Only poll during active match windows (kickoff through full time + 30min potential extra time).
Respects the free tier's 10 req/min rate limit. Stores last known state in `match_states` table.

**7. Never trigger the same deal twice.**
Before activating a deal, check `deals.triggered_at IS NULL`. Set on trigger, never reset.

---

## Real-Time

**8. Real-time via Supabase subscriptions, not polling.**
Group chat, DMs, and RSVPs use `supabase.channel()` subscriptions.
Zero polling in the mobile app.

---

## Push Notifications

**9. Push notification budget: max 3 pushes per user per match day.**
Strict curation. Trust is the product. Exceeding this trains users to disable notifications.

---

## AI / Claude Vision

**10. Claude Vision pipeline is async — never block photo upload.**
Photo upload returns immediate success. Edge Function calls Claude API in background.
Vibe tags appear in the feed 10–30 seconds after upload. Show "Analyzing vibe..." placeholder.

---

## Navigation

**11. Expo Router for navigation.**
File-based routing. Auth-protected routes via layout guards (`Stack.Protected`), not manual
navigation logic. No custom router abstractions.

---

## State Management

**12. No Redux or Zustand at launch.**
Supabase client + React Context for auth state. Local component state for everything else.
Add state management only if a specific, concrete need emerges — not speculatively.

---

## Phase Boundaries

**13. Community layer ships May 25, 2026. Venue/deals layer ships before June 11, 2026.**
Two distinct launch events. Do not conflate Phase 1 and Phase 2 scope in a single session.

**14. Supabase free tier connection limit: 200 concurrent WebSocket connections.**
If approaching 150, prioritize DMs + group chat over venue feed subscriptions.
Set up a Supabase usage alert at 150 connections before June 11.
