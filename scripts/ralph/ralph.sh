#!/bin/bash

# ralph.sh - Main loop for Ralph autonomous AI coding agent
# This script spawns Ralph iterations until all PRD stories are complete

set -e  # Exit on error

# Configuration
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PRD_FILE="$REPO_ROOT/prd.json"
PROGRESS_FILE="$REPO_ROOT/progress.txt"
PROMPT_FILE="$REPO_ROOT/scripts/ralph/prompt.md"
MAX_ITERATIONS=100  # Safety limit to prevent infinite loops

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required files exist
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if [ ! -f "$PRD_FILE" ]; then
        log_error "prd.json not found at $PRD_FILE"
        exit 1
    fi
    
    if [ ! -f "$PROMPT_FILE" ]; then
        log_error "prompt.md not found at $PROMPT_FILE"
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# Count incomplete stories
count_incomplete_stories() {
    # Count stories where "passes": false
    grep -c '"passes": false' "$PRD_FILE" || echo "0"
}

# Get next story to work on
get_next_story() {
    # Extract the first story with "passes": false
    # This is a simplified version - you may want to use jq for more robust parsing
    local story_id=$(grep -B 10 '"passes": false' "$PRD_FILE" | grep '"id"' | head -1 | sed 's/.*"id": "\(.*\)".*/\1/')
    echo "$story_id"
}

# Main loop
main() {
    log_info "Starting Ralph autonomous coding loop..."
    log_info "Repository: $REPO_ROOT"
    
    check_prerequisites
    
    local iteration=0
    
    while [ $iteration -lt $MAX_ITERATIONS ]; do
        iteration=$((iteration + 1))
        
        log_info "=== Iteration $iteration ==="
        
        # Check for incomplete stories
        local incomplete_count=$(count_incomplete_stories)
        
        if [ "$incomplete_count" -eq 0 ]; then
            log_success "All stories complete! 🎉"
            echo "<promise>COMPLETE</promise>"
            exit 0
        fi
        
        local next_story=$(get_next_story)
        log_info "Incomplete stories: $incomplete_count"
        log_info "Next story: $next_story"
        
        # Invoke Amp AI agent with the master prompt
        log_info "Invoking Amp AI agent for story: $next_story"
        
        # Construct the prompt for Amp
        local amp_prompt="You are Ralph, an autonomous AI coding agent.

Read the following files before starting:
1. $PRD_FILE - Find story $next_story
2. $PROGRESS_FILE - Review past learnings
3. $REPO_ROOT/AGENTS.md - Understand conventions

Master Prompt:
$(cat "$PROMPT_FILE")

Current Task:
Implement story $next_story from prd.json

Remember:
- Work on ONLY this one story
- Follow acceptance criteria exactly
- Run quality checks before committing
- Update prd.json, progress.txt, and AGENTS.md after commit
- Output <promise>COMPLETE</promise> when done if all stories pass"

        # Run Amp in execute mode with dangerous allow all
        # This allows Ralph to work autonomously without manual approvals
        log_info "Starting Amp execution..."
        
        if ~/.amp/bin/amp --dangerously-allow-all -x "$amp_prompt" 2>&1 | tee /tmp/ralph_iteration_$iteration.log; then
            log_success "Amp execution completed"
            
            # Check if the story was marked as complete
            if grep -q "\"id\": \"$next_story\"" "$PRD_FILE" && grep -A 5 "\"id\": \"$next_story\"" "$PRD_FILE" | grep -q '"passes": true'; then
                log_success "Story $next_story marked as complete"
            else
                log_warning "Story $next_story may not have been completed properly"
                log_info "Check the log at /tmp/ralph_iteration_$iteration.log"
            fi
        else
            log_error "Amp execution failed"
            log_info "Check the log at /tmp/ralph_iteration_$iteration.log"
            exit 1
        fi
        
        # Small delay between iterations
        sleep 2
    done
    
    if [ $iteration -eq $MAX_ITERATIONS ]; then
        log_error "Reached maximum iterations ($MAX_ITERATIONS) without completing all stories"
        exit 1
    fi
}

# Run main function
main "$@"
