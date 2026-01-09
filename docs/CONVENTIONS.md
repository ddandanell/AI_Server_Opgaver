# Project Conventions

This document outlines the conventions and standards for this project. All code and contributions should follow these guidelines.

## Commit Message Format

All commits must follow this format:

```
[STORY-ID] Brief description of change
```

**Examples:**
- `[STORY-001] Add POST /api/auth/login endpoint`
- `[STORY-002] Create users table migration`
- `[STORY-003] Add UserCard component to dashboard`

**Rules:**
- Story ID must match an ID in `prd.json`
- Description should be concise (50 chars or less)
- Use imperative mood ("Add" not "Added")
- No period at the end

## PRD Story Structure

### Required Fields

```json
{
  "id": "STORY-XXX",
  "title": "Brief title",
  "description": "Detailed description",
  "acceptanceCriteria": [
    "Criterion 1",
    "Criterion 2",
    "Criterion 3"
  ],
  "passes": false,
  "priority": 1
}
```

### Story Sizing Guidelines

**Right-sized (✅ Good):**
- Add one API endpoint
- Create one database migration
- Build one component
- Add one form field
- Update one config file

**Too large (❌ Bad):**
- "Build authentication"
- "Create dashboard"
- "Implement user management"
- "Refactor API"

### Acceptance Criteria Rules

1. **Specific**: "Returns 401 on invalid credentials" not "Handles errors"
2. **Testable**: "Migration runs with `up` command" not "Migration works"
3. **Minimal**: 3-5 criteria per story
4. **Complete**: Cover happy path and key edge cases

## State Update Requirements

After successfully completing a story, you **must** update:

### 1. prd.json

Set the story's `passes` field to `true`:

```json
{
  "id": "STORY-001",
  "passes": true
}
```

### 2. progress.txt

Append learnings in this format:

```
[YYYY-MM-DD HH:MM] [STORY-ID] Category: Description
```

**Categories:**
- `LEARNED`: New knowledge gained
- `GOTCHA`: Edge case or pitfall discovered
- `PATTERN`: Reusable pattern identified
- `WARNING`: Important caution for future iterations

**Example:**
```
[2026-01-10 04:15] [STORY-001] LEARNED: JWT tokens require SECRET_KEY in .env
[2026-01-10 04:20] [STORY-001] GOTCHA: bcrypt rounds must be 10+ for security
[2026-01-10 04:25] [STORY-001] PATTERN: Auth middleware goes in middleware/
```

### 3. AGENTS.md

Update relevant sections:
- Add new conventions discovered
- Document architectural decisions
- Add patterns to reuse
- Note warnings for future iterations

## Quality Gate Requirements

Before committing, all checks in `scripts/ralph/quality-checks.sh` must pass.

### Minimum Required Checks

Configure based on your tech stack:

**Node.js/TypeScript:**
- Type checking: `npm run type-check`
- Tests: `npm test`
- Linting: `npm run lint`
- Build: `npm run build`

**Python:**
- Tests: `pytest`
- Type checking: `mypy .`
- Formatting: `black --check .`

**Go:**
- Tests: `go test ./...`
- Vet: `go vet ./...`
- Lint: `golangci-lint run`

### Check Failure Protocol

If any check fails:
1. Do **not** commit
2. Fix the issue
3. Re-run **all** checks
4. Only commit when all pass

## Code Style

### General Principles

1. **Minimal changes**: Only modify what's necessary for the story
2. **No refactoring**: Don't touch unrelated code
3. **Follow existing patterns**: Match the codebase style
4. **Clear naming**: Use descriptive variable and function names

### File Organization

[To be updated as project structure emerges]

### Naming Conventions

[To be updated based on tech stack]

## Frontend-Specific Rules

### UI Verification

When implementing frontend stories:
1. Use dev-browser skill to verify UI
2. Explicitly confirm visual correctness
3. Test interactions and animations
4. Verify responsive behavior

### Component Structure

[To be updated as patterns emerge]

## Backend-Specific Rules

### API Endpoints

[To be updated based on framework]

### Database Migrations

[To be updated based on ORM/migration tool]

## Testing Requirements

### Unit Tests

[To be updated based on testing framework]

### Integration Tests

[To be updated as needed]

### E2E Tests

[To be updated as needed]

## Documentation Requirements

### Code Comments

- Comment complex logic
- Explain non-obvious decisions
- Document edge cases
- Keep comments up to date

### README Updates

Update README.md when:
- Adding new features
- Changing setup process
- Adding dependencies
- Modifying configuration

## Dependency Management

### Adding Dependencies

[To be updated based on package manager]

### Version Pinning

[To be updated based on project needs]

## Environment Variables

### Required Variables

[To be updated as env vars are added]

### .env File Structure

[To be updated based on project]

## Git Workflow

### Branch Strategy

[To be updated based on team workflow]

### Pull Request Requirements

[To be updated if using PRs]

## Continuous Integration

### CI Pipeline

[To be updated when CI is configured]

### Deployment Process

[To be updated when deployment is set up]

---

**Note**: This document should be updated as the project evolves. When you discover new conventions or patterns, add them here for future iterations.
