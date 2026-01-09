#!/bin/bash

# quality-checks.sh - Quality gates that must pass before committing
# Exit code 0 = all checks pass
# Exit code non-zero = at least one check failed

set -e  # Exit on first failure

# Configuration
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[CHECK]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

# Change to repo root
cd "$REPO_ROOT"

echo "================================="
echo "Running Quality Checks"
echo "================================="
echo ""

# ============================================================================
# CUSTOMIZE THESE CHECKS FOR YOUR PROJECT
# ============================================================================

# Example: Type checking (TypeScript)
# Uncomment and customize for your project
# log_info "Running type checking..."
# if npm run type-check; then
#     log_success "Type checking passed"
# else
#     log_error "Type checking failed"
#     exit 1
# fi

# Example: Unit tests
# Uncomment and customize for your project
# log_info "Running unit tests..."
# if npm test; then
#     log_success "Unit tests passed"
# else
#     log_error "Unit tests failed"
#     exit 1
# fi

# Example: Linting
# Uncomment and customize for your project
# log_info "Running linter..."
# if npm run lint; then
#     log_success "Linting passed"
# else
#     log_error "Linting failed"
#     exit 1
# fi

# Example: Build verification
# Uncomment and customize for your project
# log_info "Verifying build..."
# if npm run build; then
#     log_success "Build successful"
# else
#     log_error "Build failed"
#     exit 1
# fi

# Example: Python tests
# Uncomment and customize for your project
# log_info "Running Python tests..."
# if pytest; then
#     log_success "Python tests passed"
# else
#     log_error "Python tests failed"
#     exit 1
# fi

# Example: Go tests
# Uncomment and customize for your project
# log_info "Running Go tests..."
# if go test ./...; then
#     log_success "Go tests passed"
# else
#     log_error "Go tests failed"
#     exit 1
# fi

# ============================================================================
# PLACEHOLDER CHECK (Remove this when you add real checks)
# ============================================================================
log_info "No quality checks configured yet"
log_success "Placeholder check passed (configure real checks in quality-checks.sh)"

echo ""
echo "================================="
echo "All Quality Checks Passed ✓"
echo "================================="

exit 0
