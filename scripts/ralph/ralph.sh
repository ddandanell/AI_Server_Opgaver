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
        
        # TODO: This is where you would invoke your AI agent
        # For now, this is a placeholder that shows the structure
        log_warning "AI agent invocation not yet implemented"
        log_info "You would call your AI agent here with:"
        log_info "  - Prompt from: $PROMPT_FILE"
        log_info "  - Working directory: $REPO_ROOT"
        log_info "  - Story to implement: $next_story"
        
        # Placeholder: In a real implementation, you would:
        # 1. Invoke the AI agent with the master prompt
        # 2. Monitor its output for completion
        # 3. Check if it updated prd.json correctly
        # 4. Handle any errors
        
        # For demonstration, we'll break here
        log_warning "Breaking loop - implement AI agent invocation to continue"
        break
    done
    
    if [ $iteration -eq $MAX_ITERATIONS ]; then
        log_error "Reached maximum iterations ($MAX_ITERATIONS) without completing all stories"
        exit 1
    fi
}

# Run main function
main "$@"
