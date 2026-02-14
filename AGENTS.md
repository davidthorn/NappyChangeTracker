# AGENTS.md

This file defines strict implementation rules for any Codex/AI agent contributing to this repository.

## Scope

- These rules apply to the entire repository.
- If a user request conflicts with these rules, ask for explicit confirmation before breaking them.
- No task is complete until a rule-by-rule compliance check is reported.

## Architecture (Mandatory)

- Keep the existing layered structure:
  - `Models/`
  - `Services/`
  - `ViewModels/`
  - `Views/`
  - `Scenes/`
- New features must follow data flow:
  1. Model
  2. Service protocol + implementation
  3. ViewModel
  4. View
  5. Scene navigation wiring

## Navigation Rules (Mandatory)

- Exactly one `TabView` is allowed in the app.
- `TabView` may exist only in `ContentView.body` (or app root WindowGroup view).
- `Scene` views (`*Scene`) are navigation owners.
- `Scene` views must own `.navigationDestination(for:)` handlers.
- No nested `NavigationStack` in the same flow.
- No `TabView` inside any `Scene`.
- In-flow routing must use `NavigationLink(value:)` with `Hashable` route values.

## View and ViewModel Rules (Mandatory)

- Views must not contain business logic.
- If state/business behavior exists, create a dedicated ViewModel.
- View creates and owns its ViewModel using `@StateObject`.
- View actions launch async work with `Task` and include cancellation checks when side effects are possible.
- Form editing screens must preserve save/reset/delete behavior and delete confirmation UX.

## Service Rules (Mandatory)

- Service dependencies must be protocol-backed.
- Service implementations with mutable state must be actors.
- Streaming updates must use `AsyncStream`.
- Keep dependency injection through initializers (no singletons).

## Protocol Typing Policy (Strict)

- Do not use existential types.
- Do not use the `any` keyword unless the user explicitly and directly requests it.
- Do not use generics for dependency abstraction unless explicitly requested.
- Do not use `associatedtype` protocol abstractions unless explicitly requested.
- Default style: protocol-typed APIs (without `any`) plus protocol-backed concrete runtime implementations.

## Swift / Quality Rules (Mandatory)

- Swift 6 compatible code only.
- No deprecated APIs unless explicitly requested.
- Explicit access control for all new types and members.
- No force unwrap/cast in production code unless explicitly justified.
- Reuse deterministic collaborators (formatters/encoders/etc.); do not recreate repeatedly in hot paths.

## File Organization Rules (Mandatory)

- One data structure/type per file.
- Keep models in `Models`, services in `Services`, etc.
- New Swift files must include standard header comments used by this repo.
- Keep previews for all Views behind `#if DEBUG`.

## Change Safety

- Do not rewrite architecture patterns just to satisfy a small change.
- Prefer incremental, pattern-consistent edits.
- Preserve backward behavior unless user explicitly asks for behavior changes.

## Completion Gate (Must Report)

Before finalizing, the agent must report:

1. Which files changed.
2. Why the change follows the architecture.
3. Rule-by-rule compliance status for this AGENTS.md.
4. Build verification result (`xcodebuild` command + pass/fail).
