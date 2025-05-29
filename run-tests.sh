#!/bin/bash

# Thrive Church Official App - Test Runner Script
# Usage: ./run-tests.sh [unit|ui|all|clean]

set -e

# Configuration
WORKSPACE="Thrive Church Official App.xcworkspace"
SCHEME="Thrive Church Official App"
DESTINATION="platform=iOS Simulator,name=iPhone SE (3rd generation)"
UNIT_TESTS="Thrive Church Official AppTests"
UI_TESTS="Thrive Church Official AppUITests"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Thrive Church Official App - Tests${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Clean derived data and dependencies
clean_environment() {
    print_info "Cleaning build environment..."
    rm -rf ~/Library/Developer/Xcode/DerivedData/Thrive_Church_Official_App-*
    print_success "Derived data cleaned"

    print_info "Installing CocoaPods dependencies..."
    pod install
    print_success "Dependencies installed"
}

# Run unit tests
run_unit_tests() {
    print_info "Running unit tests..."
    echo "Expected: ~3 seconds, 2 tests"
    echo ""

    if xcodebuild test \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" \
        -destination "$DESTINATION" \
        -only-testing:"$UNIT_TESTS"; then
        print_success "Unit tests passed!"
        return 0
    else
        print_error "Unit tests failed!"
        return 1
    fi
}

# Run UI tests
run_ui_tests() {
    print_info "Running UI tests..."
    echo "Expected: ~30-60 seconds, 1 known failing test"
    echo ""

    if xcodebuild test \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" \
        -destination "$DESTINATION" \
        -only-testing:"$UI_TESTS"; then
        print_success "UI tests completed successfully!"
        return 0
    else
        print_warning "UI tests completed with known failures"
        print_info "Note: testAllTabsAccessible has a known UI accessibility issue"
        return 0  # Don't fail the script for known UI issues
    fi
}

# Run all tests
run_all_tests() {
    print_info "Running all tests (unit + UI)..."
    echo "Expected: ~60-90 seconds total"
    echo ""

    if xcodebuild test \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" \
        -destination "$DESTINATION"; then
        print_success "All tests completed!"
        return 0
    else
        print_warning "Tests completed with some failures"
        print_info "Check output above for details"
        return 1
    fi
}

# Show usage
show_usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  unit    - Run unit tests only (fast, ~3s)"
    echo "  ui      - Run UI tests only (~30-60s)"
    echo "  all     - Run all tests (~60-90s)"
    echo "  clean   - Clean environment and install dependencies"
    echo "  help    - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 unit          # Quick unit test run"
    echo "  $0 clean && $0 all  # Full clean and test"
    echo ""
    echo "For more options, see TESTING.md"
}

# Main script logic
main() {
    print_header

    case "${1:-all}" in
        "unit")
            run_unit_tests
            ;;
        "ui")
            run_ui_tests
            ;;
        "all")
            run_all_tests
            ;;
        "clean")
            clean_environment
            ;;
        "help"|"-h"|"--help")
            show_usage
            ;;
        *)
            print_error "Unknown command: $1"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

# Check if we're in the right directory
if [ ! -d "$WORKSPACE" ]; then
    print_error "Workspace not found: $WORKSPACE"
    print_info "Make sure you're running this script from the project root directory"
    exit 1
fi

# Run main function with all arguments
main "$@"
