# AGENTS.md - Conventions & Patterns for Future Iterations

> **Purpose**: This document serves as institutional memory for Ralph iterations.
> Each agent instance reads this before starting work to understand project conventions.

## Last Updated
2026-01-10 03:51:00 +08:00

---

## Project Overview

**Repository**: https://github.com/ddandanell/AI_Server_Opgaver.git  
**Purpose**: Ralph autonomous AI coding agent system  
**Tech Stack**: [TO BE DETERMINED - Update as project evolves]

---

## Coding Conventions

### General Rules
- Follow existing file structure and naming patterns
- Keep changes minimal and scoped to the current story
- Do not refactor unrelated code
- All code must pass quality checks before commit

### Commit Messages
Format: `[STORY-ID] Brief description`

Examples:
- `[STORY-001] Add POST /api/auth/login endpoint`
- `[STORY-002] Create users table migration`
- `[STORY-003] Add UserCard component to dashboard`

### File Organization
[TO BE UPDATED as patterns emerge]

---

## Quality Gates

### Required Checks (Must Pass Before Commit)
- [ ] Type checking (if applicable)
- [ ] Unit tests (if applicable)
- [ ] Linting (if applicable)
- [ ] Build verification (if applicable)

**Note**: Customize `scripts/ralph/quality-checks.sh` with project-specific commands.

---

## Common Gotchas

### Story Selection
- Always work on the highest-priority story where `"passes": false`
- Never work on multiple stories in one iteration
- If a story is too large, implement the smallest valid subset

### State Updates
After successful commit, you MUST:
1. Update `prd.json` - set `"passes": true` for completed story
2. Append to `progress.txt` - document learnings
3. Update this file (`AGENTS.md`) - add new conventions/patterns

### Frontend Verification
- Use dev-browser skill to verify UI changes
- Explicitly confirm visual correctness
- Test interactions and animations

---

## Discovered Patterns

### [TO BE UPDATED]
As iterations progress, document:
- Reusable code patterns
- Architectural decisions
- Best practices specific to this project
- Helper functions or utilities

---

## Warnings for Future Agents

### Critical Rules
1. **Never expand scope** - Implement exactly what acceptance criteria require
2. **Never skip verification** - All quality checks must pass
3. **Never assume context** - Read all state files before starting
4. **Never batch stories** - One story per iteration, always

### Known Issues
[TO BE UPDATED as issues are discovered]

---

## Tech Stack Details

### Dependencies
[TO BE UPDATED as dependencies are added]

### Development Commands
[TO BE UPDATED with actual commands]
- Install: `[TBD]`
- Dev server: `[TBD]`
- Tests: `[TBD]`
- Build: `[TBD]`
- Lint: `[TBD]`

---

## Architecture Notes

### Directory Structure
```
[TO BE UPDATED as structure emerges]
```

### Key Components
[TO BE UPDATED as components are built]

---

## Testing Strategy

### Unit Tests
[TO BE UPDATED with testing patterns]

### Integration Tests
[TO BE UPDATED with testing patterns]

### E2E Tests
[TO BE UPDATED with testing patterns]

---

## Deployment

### Environment Variables
[TO BE UPDATED with required env vars]

### Build Process
[TO BE UPDATED with build steps]

### CI/CD
[TO BE UPDATED with CI/CD configuration]

---

**Remember**: This document grows with each iteration. Always update it when you discover new patterns, conventions, or gotchas.
