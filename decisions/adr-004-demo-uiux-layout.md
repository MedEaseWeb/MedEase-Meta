# ADR-004: Demo UI/UX Layout Architecture

> Date: 2026-03-25
> Status: Accepted
> Decided by: Rolf

## Context

The public demo workflow (`/survey` → `/home` → `/community` → `/notes`) was built functional-first. By 2026-03-25 it had accumulated several structural problems:

- All pages used `minHeight: 100vh`, causing the full document to scroll as content accumulated (especially the chat window on `/home`)
- The chat message area had `overflowY: auto` but no `maxHeight` to trigger it — messages grew the page instead of scrolling internally
- MUI `Grid` negative margins broke `height: 100%` propagation through the flex chain, so the chat panel never got a real computed height
- Section nav (User Survey / Home / Community / Notes) was copy-pasted into 5+ files verbatim
- Community hub cards were tall column layouts with excessive padding — only ~70% of viewport width used
- Notes `Tabs` rendered in MUI default blue (primary color) because `textColor` was not overridden
- `NotesWeekView` rendered all 24 hours at 48px/hr = 1152px total — guaranteed to overflow any viewport
- `CommunityLayout` had its own separate copy of the section nav, separate from `DemoSectionNav`

## Options Considered

**A. Per-page `maxHeight` + `overflowY: auto` cap**
Each page wraps its card in a `maxHeight: calc(100vh - X)` constraint.
- Pro: minimal change, easy to reason about.
- Con: magic pixel values per page, doesn't fix flex chain for chat scroll.

**B. Viewport-fill flex column (chosen)**
Outer container: `height: calc(100vh - 64px), overflow: hidden, display: flex, flexDirection: column`.
Card: `flex: 1, minHeight: 0, overflow: hidden, display: flex, flexDirection: column`.
Content regions: `flex: 1, minHeight: 0, overflowY: auto`.
- Pro: no magic pixel values, flex chain propagates real heights to descendants, chat scroll works correctly.
- Con: requires every intermediate Box to carry `minHeight: 0` (flex shrink-to-fit default is `auto`).

**C. Fixed pixel heights on chat**
Set `height: 300px` on the message area.
- Pro: trivially simple.
- Con: breaks on different viewport sizes, doesn't solve `/home` page overflow, not composable.

## Decision

**Use Option B for all demo pages.**

The 64px offset matches the `mt: 8` (= 64px) applied by `App.jsx` when `TopBar` is visible. `calc(100vh - 64px)` therefore fills exactly the visible area below the TopBar.

The chat flex chain: `outer Box (h: calc(100vh-64px))` → `Paper (flex: 1, minHeight: 0)` → `wrapper Box (flex: 1, minHeight: 0)` → `QuestionsInTheLoopSection root (h: 100%)` → `chat Panel Box (flex: 1, minHeight: 0)` → `message area (flex: 1, minHeight: 0, overflowY: auto)`.

**MUI Grid was removed** from `QuestionsInTheLoopSection` and replaced with a plain `Box` flex row. MUI Grid uses negative margins that cause `height: 100%` to resolve against the wrong ancestor, breaking the chain.

**`DemoSectionNav`** extracted as a single shared component at `frontend/src/pages/utility/DemoSectionNav.jsx`. Active state logic (including `/home` matching both `/home` and `/questions-in-the-loop`) is centralized here. All demo pages and `CommunityLayout` import it.

## Consequences

- Demo pages no longer scroll at the document level.
- Adding a new demo page requires following the `height: calc(100vh - 64px)` / `flex: 1, minHeight: 0` pattern — document this for future contributors.
- If TopBar height ever changes from 64px, the offset needs updating in: `SurveyShell`, `QuestionsInTheLoopPage`, `CommunityLayout`, `CommunityPage`, `NotesPage`. Consider extracting `TOPBAR_HEIGHT = 64` as a shared token.
- `DemoSectionNav` is the single place to add/rename/reorder demo nav items.
- `NotesWeekView` now shows 7am–10pm only (hours 7–22). Events outside this range are clipped. If users commonly schedule outside this range, widen or add an "all hours" toggle.

---

*Related: [[feature-registry]] · [[short-term]] · [[2026-03-25-sprint]]*
