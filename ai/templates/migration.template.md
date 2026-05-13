# Migration: {{NAME}}

- **id**: {{YYYYMMDDHHMMSS}}
- **status**: pending
- **author**: {{author}}
- **created_at**: {{YYYY-MM-DD}}

## Motivation

Why does this change need to happen? Reference the business or operational
driver (incident, compliance, user-facing goal). Keep it concrete — avoid
"clean up X" without a reason.

## Scope

What is and is not included. Bound the migration so the smallest useful
increment can ship.

**In scope:**
- ...

**Out of scope:**
- ...

## Dependencies

Other migrations or external prerequisites that must land first.

- depends_on: []

## Acceptance Criteria

Observable, testable outcomes. Each line should map to a test (or a manual
verification step if automation is impossible).

- [ ] ...
- [ ] ...

## Risks

What could go wrong, and what we'll do about it. Note any production
data, queue state, or external service that could be affected.

## Rollback Strategy

How to revert if the migration goes wrong. For Code Migrations this is
usually `git revert <sha>` plus any data restoration steps; spell out the
data steps if they exist.

## Notes

Free-form context for the Navigator and Driver. Links to ADRs, related
issues, screenshots, etc.
