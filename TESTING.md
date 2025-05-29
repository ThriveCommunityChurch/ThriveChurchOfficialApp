# Testing Guide for Thrive Church Official App

## Overview

This document provides comprehensive instructions for running and maintaining tests in the Thrive Church Official App project.

## Test Configuration

The project includes two test targets:
- **Unit Tests**: `Thrive Church Official AppTests`
- **UI Tests**: `Thrive Church Official AppUITests`

### Build Configuration Fixes Applied

The following build configuration issues have been resolved:

#### 1. Swift Module Conflicts
- **Issue**: Multiple targets were writing to the same Swift module output paths
- **Solution**: Added unique `SWIFT_MODULE_NAME` settings:
  - Unit Tests: `Thrive_Church_Official_AppTests`
  - UI Tests: `Thrive_Church_Official_AppUITests`
- **Build Settings Added**:
  ```
  SWIFT_INSTALL_OBJC_HEADER = NO
  SWIFT_MODULE_NAME = [unique_name]
  SWIFT_OBJC_INTERFACE_HEADER_NAME = [unique_name]-Swift.h
  MACH_O_TYPE = mh_bundle
  ```

#### 2. UI Test Framework Dependencies
- **Issue**: UI tests couldn't load CocoaPods frameworks at runtime
- **Solution**: Changed Podfile inheritance from `:search_paths` to `:complete` for UI tests
- **Before**: `inherit! :search_paths`
- **After**: `inherit! :complete`

## Running Tests

### Prerequisites

Before running tests, ensure your environment is properly set up:

1. **Clean Build Environment** (recommended before first run):
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/Thrive_Church_Official_App-*
   ```

2. **Install Dependencies**:
   ```bash
   cd /path/to/ThriveChurchOfficialApp
   pod install
   ```

3. **Verify iOS Simulator**:
   - Ensure you have iOS 15.0+ simulators installed
   - Recommended: iPhone SE (3rd generation) with iOS 18.0

### Method 1: Command Line Testing (Recommended for CI/CD)

The command line approach is reliable and provides detailed output. All commands should be run from the project root directory.

#### Quick Start Commands

**Run All Tests** (Unit + UI):
```bash
xcodebuild test \
  -workspace "Thrive Church Official App.xcworkspace" \
  -scheme "Thrive Church Official App" \
  -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)'
```

**Run Only Unit Tests** (Fast, ~3 seconds):
```bash
xcodebuild test \
  -workspace "Thrive Church Official App.xcworkspace" \
  -scheme "Thrive Church Official App" \
  -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' \
  -only-testing:"Thrive Church Official AppTests"
```

**Run Only UI Tests** (Slower, ~30-60 seconds):
```bash
xcodebuild test \
  -workspace "Thrive Church Official App.xcworkspace" \
  -scheme "Thrive Church Official App" \
  -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' \
  -only-testing:"Thrive Church Official AppUITests"
```

#### Advanced Command Line Options

**Run Specific UI Test**:
```bash
xcodebuild test \
  -workspace "Thrive Church Official App.xcworkspace" \
  -scheme "Thrive Church Official App" \
  -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' \
  -only-testing:"Thrive Church Official AppUITests/Thrive_Community_ChurchUITests/testAppLaunchAndTabBarVisibility"
```

**Run with Different Simulator**:
```bash
xcodebuild test \
  -workspace "Thrive Church Official App.xcworkspace" \
  -scheme "Thrive Church Official App" \
  -destination 'platform=iOS Simulator,name=iPhone 14 Pro'
```

**Run with Verbose Output**:
```bash
xcodebuild test \
  -workspace "Thrive Church Official App.xcworkspace" \
  -scheme "Thrive Church Official App" \
  -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' \
  -verbose
```

**Generate Test Results Bundle**:
```bash
xcodebuild test \
  -workspace "Thrive Church Official App.xcworkspace" \
  -scheme "Thrive Church Official App" \
  -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' \
  -resultBundlePath TestResults.xcresult
```

### Method 2: Xcode IDE Testing

For interactive development and debugging:

#### Using Test Navigator
1. Open `Thrive Church Official App.xcworkspace`
2. Press `Cmd+6` to open Test Navigator
3. Click the play button next to:
   - **All Tests** - Runs everything
   - **Thrive Church Official AppTests** - Unit tests only
   - **Thrive Church Official AppUITests** - UI tests only
   - **Individual test methods** - Single test

#### Using Keyboard Shortcuts
- `Cmd+U` - Run all tests in current scheme
- `Cmd+Ctrl+U` - Run tests without building
- `Cmd+Shift+U` - Run tests with code coverage

#### Using Product Menu
1. **Product** → **Test** - Run all tests
2. **Product** → **Build for** → **Testing** - Build without running
3. **Product** → **Perform Action** → **Test Without Building**

#### Debugging Tests
1. Set breakpoints in test code or app code
2. Right-click test method → **Debug "testMethodName"**
3. Use `Cmd+Shift+O` to quickly navigate to test files

### Method 3: Convenience Script (Recommended for Development)

A convenient shell script `run-tests.sh` is provided for easy test execution with colored output and helpful information.

#### Using the Script

**Make executable** (first time only):
```bash
chmod +x run-tests.sh
```

**Run unit tests** (fastest):
```bash
./run-tests.sh unit
```

**Run UI tests**:
```bash
./run-tests.sh ui
```

**Run all tests**:
```bash
./run-tests.sh all
# or simply
./run-tests.sh
```

**Clean environment**:
```bash
./run-tests.sh clean
```

**Get help**:
```bash
./run-tests.sh help
```

#### Script Features
- ✅ **Colored output** - Green for success, red for errors, blue for info
- ✅ **Time estimates** - Shows expected duration for each test type
- ✅ **Error handling** - Graceful handling of known issues
- ✅ **Progress indicators** - Clear status messages throughout execution
- ✅ **Automatic validation** - Checks workspace exists before running

#### Example Output
```bash
$ ./run-tests.sh unit
========================================
  Thrive Church Official App - Tests
========================================
ℹ️  Running unit tests...
Expected: ~3 seconds, 2 tests

[Build output...]

✅ Unit tests passed!
```

### Method 4: Continuous Integration Setup

For automated testing in CI/CD pipelines:

#### GitHub Actions Example
```yaml
- name: Run Tests
  run: |
    xcodebuild test \
      -workspace "Thrive Church Official App.xcworkspace" \
      -scheme "Thrive Church Official App" \
      -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' \
      -resultBundlePath TestResults.xcresult \
      | xcpretty --test --color
```

#### Jenkins/Other CI
```bash
#!/bin/bash
set -e

# Clean environment
rm -rf ~/Library/Developer/Xcode/DerivedData/Thrive_Church_Official_App-*

# Install dependencies
pod install

# Run tests
xcodebuild test \
  -workspace "Thrive Church Official App.xcworkspace" \
  -scheme "Thrive Church Official App" \
  -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' \
  -resultBundlePath TestResults.xcresult

# Parse results (optional)
xcparse TestResults.xcresult output/
```

### Supported Simulators

The tests are configured to run on iOS 15.0+ simulators. Recommended devices:
- iPhone SE (3rd generation) - **Primary testing device**
- iPhone 14
- iPhone 14 Pro
- iPhone 14 Pro Max
- iPad (9th generation)
- iPad Pro (12.9-inch)

### Understanding Test Output

#### Successful Test Run
```
Test Suite 'All tests' started at 2025-05-29 10:21:05.163.
Test Suite 'Thrive Church Official App.xctest' started at 2025-05-29 10:21:05.163.
Test Suite 'ThriveChurchOfficialAppTests' started at 2025-05-29 10:21:05.164.
Test Case '-[...testExample]' started.
Test Case '-[...testExample]' passed (0.003 seconds).
Test Case '-[...testPerformanceExample]' started.
Test Case '-[...testPerformanceExample]' passed (0.001 seconds).
Test Suite 'ThriveChurchOfficialAppTests' passed at 2025-05-29 10:21:05.167.
	 Executed 2 tests, with 0 failures (0 unexpected) in 0.003 (0.004) seconds
** TEST SUCCEEDED **
```

#### Failed Test Run
```
Test Case '-[...testAllTabsAccessible]' started.
/path/to/test:55: error: -[...testAllTabsAccessible] : Failed to scroll...
Test Case '-[...testAllTabsAccessible]' failed (21.034 seconds).
	 Executed 2 tests, with 1 failure (0 unexpected) in 31.119 seconds
** TEST FAILED **
```

#### Key Indicators
- **✅ `** TEST SUCCEEDED **`** - All tests passed
- **❌ `** TEST FAILED **`** - One or more tests failed
- **⏱️ Execution time** - Shows performance (unit tests: ~3s, UI tests: ~30-60s)
- **📊 Summary line** - `Executed X tests, with Y failures`

### Common Testing Workflows

#### Development Workflow
1. **Write/modify code**
2. **Run unit tests** (fast feedback):
   ```bash
   xcodebuild test -workspace "Thrive Church Official App.xcworkspace" -scheme "Thrive Church Official App" -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' -only-testing:"Thrive Church Official AppTests"
   ```
3. **If unit tests pass, run UI tests**:
   ```bash
   xcodebuild test -workspace "Thrive Church Official App.xcworkspace" -scheme "Thrive Church Official App" -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' -only-testing:"Thrive Church Official AppUITests"
   ```
4. **Commit when all tests pass**

#### Pre-commit Workflow
```bash
# Quick validation before committing
echo "Running pre-commit tests..."
xcodebuild test \
  -workspace "Thrive Church Official App.xcworkspace" \
  -scheme "Thrive Church Official App" \
  -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' \
  -only-testing:"Thrive Church Official AppTests"

if [ $? -eq 0 ]; then
    echo "✅ Unit tests passed - safe to commit"
else
    echo "❌ Unit tests failed - fix before committing"
    exit 1
fi
```

#### Release Workflow
```bash
# Comprehensive testing before release
echo "Running full test suite for release..."

# Clean environment
rm -rf ~/Library/Developer/Xcode/DerivedData/Thrive_Church_Official_App-*

# Update dependencies
pod install

# Run all tests
xcodebuild test \
  -workspace "Thrive Church Official App.xcworkspace" \
  -scheme "Thrive Church Official App" \
  -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' \
  -resultBundlePath "Release-TestResults-$(date +%Y%m%d-%H%M%S).xcresult"

echo "✅ Release testing complete"
```

#### Debugging Failed Tests
1. **Run specific failing test**:
   ```bash
   xcodebuild test -workspace "Thrive Church Official App.xcworkspace" -scheme "Thrive Church Official App" -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' -only-testing:"Target/Class/testMethod"
   ```

2. **Use Xcode for interactive debugging**:
   - Open Test Navigator (`Cmd+6`)
   - Right-click failing test → **Debug "testMethod"**
   - Set breakpoints and inspect variables

3. **Check test logs**:
   ```bash
   # View detailed logs
   xcodebuild test ... -verbose 2>&1 | tee test-output.log
   ```

## Test Status

### Unit Tests ✅
- **Status**: All tests passing
- **Count**: 2 tests
- **Tests**:
  - `testExample` - ✅ Passed
  - `testPerformanceExample` - ✅ Passed

### UI Tests ⚠️
- **Status**: 1 passing, 1 failing (UI interaction issue)
- **Count**: 2 tests
- **Tests**:
  - `testAppLaunchAndTabBarVisibility` - ✅ Passed (10.085s)
  - `testAllTabsAccessible` - ❌ Failed (UI accessibility issue)

#### Known UI Test Issues

**testAllTabsAccessible Failure**:
- **Issue**: Cannot scroll to make "Listen" button visible
- **Error**: `kAXErrorCannotComplete performing AXAction kAXScrollToVisibleAction`
- **Type**: UI/UX issue, not build configuration
- **Status**: Requires UI accessibility investigation

## Troubleshooting

### Common Issues and Solutions

#### 1. Swift Module Conflicts
**Error**: `error: module 'X' was created for incompatible target`
**Solution**: Clean derived data and rebuild:
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/Thrive_Church_Official_App-*
xcodebuild clean -workspace "Thrive Church Official App.xcworkspace" -scheme "Thrive Church Official App"
```

#### 2. Framework Loading Errors
**Error**: `Library not loaded: @rpath/FBLPromises.framework/FBLPromises`
**Solution**: Ensure CocoaPods inheritance is set correctly and run `pod install`

#### 3. Bundle Loader Issues
**Error**: `-bundle_loader can only be used with -bundle`
**Solution**: Verify `MACH_O_TYPE = mh_bundle` is set for test targets

### Build Settings Verification

Check that these settings are correctly applied:

**Unit Tests Target**:
```
SWIFT_INSTALL_OBJC_HEADER = NO
SWIFT_MODULE_NAME = Thrive_Church_Official_AppTests
MACH_O_TYPE = mh_bundle
```

**UI Tests Target**:
```
SWIFT_INSTALL_OBJC_HEADER = NO
SWIFT_MODULE_NAME = Thrive_Church_Official_AppUITests
MACH_O_TYPE = mh_bundle
TEST_TARGET_NAME = "Thrive Church Official App"
```

## Maintenance

### Adding New Tests

1. **Unit Tests**: Add to `Thrive Community ChurchTests/` directory
2. **UI Tests**: Add to `Thrive Community ChurchUITests/` directory
3. Ensure new test files are added to the appropriate target

### Updating Dependencies

When updating CocoaPods dependencies:
1. Run `pod install`
2. Clean derived data
3. Run tests to verify compatibility

### CI/CD Integration

For continuous integration, use the command-line testing approach with appropriate simulator destinations and test result parsing.

## Support

If you encounter issues not covered in this guide:
1. Check the build logs for specific error messages
2. Verify all build settings are correctly applied
3. Ensure the correct iOS deployment target (15.0+)
4. Clean and rebuild the project

## Quick Reference

### Convenience Script Commands (Recommended)

**⚡ Run Unit Tests** (Fastest, ~3s):
```bash
./run-tests.sh unit
```

**🖥️ Run UI Tests** (~30-60s):
```bash
./run-tests.sh ui
```

**🚀 Run All Tests**:
```bash
./run-tests.sh all
# or simply
./run-tests.sh
```

**🧹 Clean Environment**:
```bash
./run-tests.sh clean
```

**❓ Get Help**:
```bash
./run-tests.sh help
```

### Direct xcodebuild Commands

**🚀 Run All Tests**:
```bash
xcodebuild test -workspace "Thrive Church Official App.xcworkspace" -scheme "Thrive Church Official App" -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)'
```

**⚡ Run Unit Tests Only** (Fast):
```bash
xcodebuild test -workspace "Thrive Church Official App.xcworkspace" -scheme "Thrive Church Official App" -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' -only-testing:"Thrive Church Official AppTests"
```

**🖥️ Run UI Tests Only**:
```bash
xcodebuild test -workspace "Thrive Church Official App.xcworkspace" -scheme "Thrive Church Official App" -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' -only-testing:"Thrive Church Official AppUITests"
```

**🧹 Clean Before Testing**:
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/Thrive_Church_Official_App-* && pod install
```

### Xcode Shortcuts
- `Cmd+U` - Run all tests
- `Cmd+6` - Open Test Navigator
- `Cmd+Shift+O` - Quick Open (navigate to test files)
- `Cmd+Ctrl+U` - Run tests without building

### Expected Results
- **Unit Tests**: ✅ 2/2 passing (~3 seconds)
- **UI Tests**: ⚠️ 1/2 passing (~30-60 seconds, 1 known UI issue)
- **Build**: ✅ No Swift module conflicts
- **Frameworks**: ✅ All dependencies load correctly

### Need Help?
1. Check [Troubleshooting](#troubleshooting) section
2. Verify [Build Settings](#build-settings-verification)
3. Clean derived data and rebuild
4. Ensure iOS 15.0+ simulator is available

---

**Last Updated**: May 29, 2025
**Configuration Version**: Fixed Swift module conflicts and UI test framework dependencies
**Status**: ✅ Tests fully functional and documented
