# Amp Integration Guide

This document explains how to use Amp CLI with the Ralph autonomous agent system.

## Overview

Amp CLI is now integrated with Ralph to provide the AI agent execution layer. When Ralph runs, it:
1. Constructs a prompt with the master instructions
2. Invokes Amp in execute mode (`--dangerously-allow-all -x`)
3. Monitors the output for completion
4. Validates that the story was marked complete

## Prerequisites

### Install Amp CLI

```bash
curl -fsSL https://ampcode.com/install.sh | bash
```

After installation, restart your shell or run:
```bash
export PATH="$HOME/.amp/bin:$PATH"
```

### Configure Amp API Key

Get your API key from https://ampcode.com/settings

```bash
export AMP_API_KEY="your-api-key-here"
```

Add this to your `~/.zshrc` or `~/.bashrc` to persist:
```bash
echo 'export AMP_API_KEY="your-api-key-here"' >> ~/.zshrc
```

## Running Ralph with Amp

### Basic Usage

```bash
./scripts/ralph/ralph.sh
```

Ralph will:
- Read `prd.json` to find incomplete stories
- Invoke Amp with the master prompt from `scripts/ralph/prompt.md`
- Execute the story implementation
- Update state files (`prd.json`, `progress.txt`, `AGENTS.md`)
- Loop to the next story

### Iteration Logs

Each iteration is logged to `/tmp/ralph_iteration_N.log` where N is the iteration number.

View the latest iteration:
```bash
tail -f /tmp/ralph_iteration_*.log
```

### Monitoring Progress

**Watch for story completion:**
```bash
watch -n 2 'grep -c "\"passes\": true" prd.json'
```

**View learning log:**
```bash
tail -f progress.txt
```

**Check current iteration:**
```bash
ps aux | grep amp
```

## How Amp Integration Works

### Prompt Construction

Ralph constructs a comprehensive prompt for each iteration:

```
You are Ralph, an autonomous AI coding agent.

Read the following files before starting:
1. /path/to/prd.json - Find story STORY-XXX
2. /path/to/progress.txt - Review past learnings
3. /path/to/AGENTS.md - Understand conventions

Master Prompt:
[Full content of scripts/ralph/prompt.md]

Current Task:
Implement story STORY-XXX from prd.json

Remember:
- Work on ONLY this one story
- Follow acceptance criteria exactly
- Run quality checks before committing
- Update prd.json, progress.txt, and AGENTS.md after commit
```

### Autonomous Execution

Amp runs with `--dangerously-allow-all` flag, which:
- Disables all command confirmation prompts
- Allows autonomous file editing
- Enables automatic git commits
- Permits running quality check scripts

**⚠️ Warning**: This gives Amp full control. Only use in controlled environments.

### Completion Detection

After Amp finishes, Ralph checks:
1. Did the story's `"passes"` field change to `true`?
2. Was the output logged successfully?
3. Did any errors occur?

## Configuration Options

### Amp Settings

Create or edit `~/.config/amp/settings.json`:

```json
{
  "amp.dangerouslyAllowAll": true,
  "amp.git.commit.coauthor.enabled": true,
  "amp.git.commit.ampThread.enabled": true,
  "amp.notifications.enabled": false,
  "amp.showCosts": true
}
```

### Ralph Settings

Edit `scripts/ralph/ralph.sh` to customize:

```bash
MAX_ITERATIONS=100  # Maximum iterations before stopping
```

## Troubleshooting

### Amp Not Found

If you get "command not found: amp":

```bash
# Check installation
ls -la ~/.amp/bin/amp

# Add to PATH
export PATH="$HOME/.amp/bin:$PATH"

# Verify
amp --version
```

### API Key Issues

If Amp fails with authentication errors:

```bash
# Check if key is set
echo $AMP_API_KEY

# Set it if missing
export AMP_API_KEY="your-key"

# Or use Amp's built-in auth
amp login
```

### Story Not Completing

If a story doesn't get marked complete:

1. Check the iteration log: `cat /tmp/ralph_iteration_N.log`
2. Verify quality checks passed: `./scripts/ralph/quality-checks.sh`
3. Manually check if code was committed: `git log`
4. Review `progress.txt` for errors

### Infinite Loop

If Ralph keeps retrying the same story:

1. Check if `prd.json` is being updated
2. Verify the story's acceptance criteria are achievable
3. Check iteration logs for recurring errors
4. Consider breaking the story into smaller pieces

## Safety Considerations

### Dangerous Allow All

The `--dangerously-allow-all` flag gives Amp full autonomy. This means:

✅ **Pros:**
- Fully autonomous execution
- No manual intervention needed
- True "lights-out" operation

⚠️ **Cons:**
- Can make destructive changes
- Can push to remote repositories
- Can install dependencies
- Can modify any file

### Recommended Safeguards

1. **Use a dedicated branch:**
   ```bash
   git checkout -b ralph-automation
   ```

2. **Test in a clone:**
   ```bash
   git clone /path/to/repo /tmp/ralph-test
   cd /tmp/ralph-test
   ./scripts/ralph/ralph.sh
   ```

3. **Review commits before pushing:**
   ```bash
   git log --oneline
   git diff origin/main
   ```

4. **Set up branch protection:**
   - Require pull requests
   - Require reviews
   - Prevent force pushes

## Advanced Usage

### Custom Amp Mode

Edit `ralph.sh` to use different Amp modes:

```bash
# Use smart mode (default)
~/.amp/bin/amp --mode smart --dangerously-allow-all -x "$amp_prompt"

# Use rush mode (faster, cheaper)
~/.amp/bin/amp --mode rush --dangerously-allow-all -x "$amp_prompt"
```

### MCP Server Integration

Add MCP servers for additional capabilities:

```bash
# Add filesystem access
amp mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem /path/to/project

# Add database access
amp mcp add postgres --env PGUSER=user -- npx -y @modelcontextprotocol/server-postgres postgresql://localhost/db
```

### Parallel Execution

**⚠️ Not recommended** but possible with GNU parallel:

```bash
# Split stories into separate prd files
# Run multiple Ralph instances
parallel ./scripts/ralph/ralph.sh ::: prd-*.json
```

## Cost Management

Amp tracks costs automatically. View costs:

```bash
# Enable cost display in settings
echo '{"amp.showCosts": true}' > ~/.config/amp/settings.json

# Costs are shown after each iteration
```

Estimate costs before running:
- Each story typically uses 1-5 iterations
- Each iteration costs $0.01-$0.50 depending on complexity
- Monitor via Amp dashboard: https://ampcode.com/usage

## Best Practices

1. **Start with small stories**: Test with simple stories first
2. **Monitor early iterations**: Watch the first few to ensure proper behavior
3. **Review commits regularly**: Don't let too many iterations run unattended
4. **Keep quality checks strict**: Better to fail fast than commit broken code
5. **Update AGENTS.md frequently**: Help future iterations learn faster

## Example Session

```bash
# 1. Set up environment
export AMP_API_KEY="your-key"

# 2. Add a story to prd.json
# (Edit prd.json to add STORY-004)

# 3. Run Ralph
./scripts/ralph/ralph.sh

# Output:
# [INFO] Starting Ralph autonomous coding loop...
# [INFO] === Iteration 1 ===
# [INFO] Incomplete stories: 4
# [INFO] Next story: STORY-004
# [INFO] Invoking Amp AI agent for story: STORY-004
# [INFO] Starting Amp execution...
# [SUCCESS] Amp execution completed
# [SUCCESS] Story STORY-004 marked as complete
# [INFO] === Iteration 2 ===
# ...

# 4. Review results
git log --oneline
cat progress.txt
```

## Resources

- **Amp Documentation**: https://ampcode.com/docs
- **Amp Settings**: https://ampcode.com/settings
- **Ralph Master Prompt**: `scripts/ralph/prompt.md`
- **Quality Checks**: `scripts/ralph/quality-checks.sh`

---

**Remember**: Ralph + Amp is a powerful combination. Use responsibly, monitor actively, and always review the output.
