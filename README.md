# Ralph Autonomous AI Coding Agent

Ralph is an autonomous AI coding agent that executes PRD (Product Requirements Document) user stories in a loop. Each iteration is stateless except for explicitly persisted data, ensuring consistent and predictable behavior across runs.

## 🎯 Overview

Ralph operates on a simple principle: **one story, one iteration, zero assumptions**. Each run:
- Reads state from `prd.json`, `progress.txt`, and `AGENTS.md`
- Selects the highest-priority incomplete story
- Implements exactly what the acceptance criteria require
- Runs quality checks
- Commits and updates state
- Exits cleanly for the next iteration

## 🚀 Quick Start

### Prerequisites

- Git configured with access to your repository
- Your project's development environment set up
- Quality check commands configured in `scripts/ralph/quality-checks.sh`

### Initial Setup

1. **Clone or initialize your repository**
   ```bash
   git clone https://github.com/ddandanell/AI_Server_Opgaver.git
   cd AI_Server_Opgaver
   ```

2. **Verify core files exist**
   - `prd.json` - Your user stories
   - `progress.txt` - Learning log
   - `AGENTS.md` - Conventions and patterns
   - `scripts/ralph/prompt.md` - Master prompt
   - `scripts/ralph/ralph.sh` - Main loop
   - `scripts/ralph/quality-checks.sh` - Quality gates

3. **Customize quality checks**
   Edit `scripts/ralph/quality-checks.sh` with your project-specific commands:
   ```bash
   # Example for Node.js/TypeScript
   npm run type-check
   npm test
   npm run lint
   npm run build
   ```

4. **Add your user stories to prd.json**
   See [Writing Good Stories](#writing-good-stories) below.

### Running Ralph

```bash
./scripts/ralph/ralph.sh
```

Ralph will:
1. Check prerequisites
2. Find the next incomplete story
3. Invoke the AI agent (when implemented)
4. Loop until all stories are complete or max iterations reached

## 📝 Writing Good Stories

### Story Structure

Each story in `prd.json` follows this format:

```json
{
  "id": "STORY-001",
  "title": "Brief description",
  "description": "Detailed description of what to build",
  "acceptanceCriteria": [
    "Specific, testable requirement 1",
    "Specific, testable requirement 2",
    "Specific, testable requirement 3"
  ],
  "passes": false,
  "priority": 1
}
```

### Right-Sized Stories ✅

**Good examples:**
- Add a single API endpoint (`POST /api/auth/login`)
- Create one database migration (add `users` table)
- Build one reusable component (`UserCard`)
- Add one form field with validation
- Update one configuration file

**Bad examples (too large):**
- "Build authentication system" ❌
- "Create admin dashboard" ❌
- "Implement user management" ❌
- "Refactor entire API" ❌

### Acceptance Criteria Guidelines

- **Be specific**: "Returns 401 on invalid credentials" not "Handles errors"
- **Be testable**: "Migration runs with `up` command" not "Migration works"
- **Be minimal**: 3-5 criteria per story
- **Be complete**: Cover happy path and key edge cases

## 🏗️ Project Structure

```
.
├── prd.json                    # User stories and completion status
├── progress.txt                # Cross-iteration learning log
├── AGENTS.md                   # Conventions and patterns
├── scripts/
│   └── ralph/
│       ├── prompt.md           # Master prompt for AI agent
│       ├── ralph.sh            # Main loop script
│       └── quality-checks.sh   # Quality gates
├── docs/
│   └── CONVENTIONS.md          # Project conventions
└── README.md                   # This file
```

## 🔄 How Ralph Works

### Iteration Flow

```
1. Read State
   ├── prd.json (stories)
   ├── progress.txt (learnings)
   └── AGENTS.md (conventions)
   
2. Select Story
   └── Highest priority where passes: false
   
3. Implement
   ├── Follow acceptance criteria exactly
   ├── Keep changes minimal and scoped
   └── Follow existing conventions
   
4. Quality Checks
   ├── Type checking
   ├── Tests
   ├── Linting
   └── Build verification
   
5. Commit
   └── Format: [STORY-ID] Description
   
6. Update State
   ├── prd.json: Set passes: true
   ├── progress.txt: Append learnings
   └── AGENTS.md: Update conventions
   
7. Exit
   └── Loop spawns next iteration
```

### State Persistence

Ralph has **zero memory** between iterations except:

1. **Git history** - All code changes
2. **prd.json** - Story completion status
3. **progress.txt** - Learnings and gotchas
4. **AGENTS.md** - Conventions and patterns

This ensures each iteration starts fresh with complete context.

## ✅ Quality Gates

Before committing, Ralph **must** pass all quality checks defined in `scripts/ralph/quality-checks.sh`.

### Configuring Quality Checks

Edit `scripts/ralph/quality-checks.sh` to match your tech stack:

**Node.js/TypeScript:**
```bash
npm run type-check
npm test
npm run lint
npm run build
```

**Python:**
```bash
pytest
mypy .
black --check .
```

**Go:**
```bash
go test ./...
go vet ./...
golangci-lint run
```

### Check Failure Behavior

If any check fails:
1. Ralph does **not** commit
2. Ralph fixes the issue
3. Ralph re-runs all checks
4. Only commits when all checks pass

## 🎓 Learning & Conventions

### progress.txt

Append-only log of learnings across iterations:

```
[2026-01-10 03:51] [STORY-001] LEARNED: JWT tokens require secret in env
[2026-01-10 04:15] [STORY-001] GOTCHA: bcrypt rounds must be 10+ for security
[2026-01-10 04:30] [STORY-002] PATTERN: Migrations go in db/migrations/
```

### AGENTS.md

Living documentation that grows with the project:
- Coding conventions
- Architectural decisions
- Common patterns
- Known gotchas
- Tech stack details

Future iterations read this to understand project standards.

## 🛡️ Safety & Constraints

### Hard Rules

- **One story per iteration** - Never batch or combine
- **No scope expansion** - Implement exactly what's required
- **No refactoring** - Don't touch unrelated code
- **No assumptions** - Read all state files first
- **Quality gates required** - All checks must pass

### Safety Limits

- **Max iterations**: 100 (configurable in `ralph.sh`)
- **Stop condition**: All stories have `"passes": true`
- **Output signal**: `<promise>COMPLETE</promise>`

## 🔧 Customization

### Project-Specific Configuration

1. **Quality checks**: Edit `scripts/ralph/quality-checks.sh`
2. **Conventions**: Update `AGENTS.md` as patterns emerge
3. **Commit format**: Modify in `AGENTS.md` if needed
4. **Max iterations**: Change `MAX_ITERATIONS` in `ralph.sh`

### Tech Stack Integration

Ralph is tech-stack agnostic. Configure for your stack:

- **Frontend**: Add browser verification steps
- **Backend**: Add API testing
- **Database**: Add migration checks
- **Mobile**: Add build verification

## 📊 Monitoring Progress

### Check Story Status

```bash
# Count incomplete stories
grep -c '"passes": false' prd.json

# View next story
grep -B 10 '"passes": false' prd.json | grep '"id"' | head -1
```

### View Learning Log

```bash
tail -20 progress.txt
```

### Review Conventions

```bash
cat AGENTS.md
```

## 🐛 Troubleshooting

### Ralph doesn't start

- Check `prd.json` exists and is valid JSON
- Verify `scripts/ralph/prompt.md` exists
- Ensure scripts are executable: `chmod +x scripts/ralph/*.sh`

### Quality checks fail

- Run `./scripts/ralph/quality-checks.sh` manually
- Fix issues in your codebase
- Ensure all dependencies are installed

### Stories not completing

- Check story is right-sized (not too large)
- Verify acceptance criteria are clear and testable
- Review `progress.txt` for patterns

### Infinite loop

- Check `MAX_ITERATIONS` in `ralph.sh`
- Verify stories are being marked `"passes": true`
- Review Git history for commit patterns

## 🎯 Best Practices

### Story Writing

1. **Start small** - One component, one endpoint, one migration
2. **Be specific** - Clear acceptance criteria
3. **Be testable** - Can verify completion objectively
4. **Prioritize** - Use priority field for ordering

### Maintenance

1. **Review progress.txt** - Learn from past iterations
2. **Update AGENTS.md** - Keep conventions current
3. **Refine quality checks** - Add checks as project grows
4. **Monitor Git history** - Ensure clean commits

### Scaling

1. **Break large features** - Into multiple right-sized stories
2. **Document patterns** - In AGENTS.md for reuse
3. **Refine conventions** - As project matures
4. **Adjust quality gates** - As requirements change

## 📚 Additional Resources

- **Master Prompt**: `scripts/ralph/prompt.md` - Ralph's core instructions
- **Conventions**: `docs/CONVENTIONS.md` - Project-specific guidelines
- **Learning Log**: `progress.txt` - Historical learnings
- **Agent Memory**: `AGENTS.md` - Institutional knowledge

## 🤝 Contributing

Ralph is designed to be self-improving:

1. Each iteration learns and documents
2. `AGENTS.md` grows with the project
3. `progress.txt` captures gotchas
4. Future iterations benefit from past learnings

This creates a **machine that builds machines** - Ralph gets smarter with each story completed.

---

**Remember**: Ralph exists to finish tasks, not to be clever. Keep stories small, criteria clear, and let the loop do its work.
