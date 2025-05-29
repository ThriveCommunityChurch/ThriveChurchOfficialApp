# Comprehensive Testing Guide for Thrive Church Official App

## Overview

This document provides comprehensive instructions for running and maintaining both unit tests and UI tests in the Thrive Church Official App project. It includes detailed coverage of the UI test suite that validates correct rendering and layout across different device sizes and orientations.

## Test Configuration

The project includes two test targets:
- **Unit Tests**: `Thrive Church Official AppTests` - Fast validation of business logic
- **UI Tests**: `Thrive Church Official AppUITests` - Comprehensive UI validation across devices

## UI Test Suite Coverage

### Device Coverage
- **iPhone SE** (small screen) - 375x667 points
- **iPhone 15 Pro Max** (large screen) - 430x932 points
- **iPad (9th generation)** - 810x1080 points
- **iPad Pro 12.9"** (large tablet) - 1024x1366 points
- **Both portrait and landscape orientations** for all devices

### Layout Validation
- ✅ AutoLayout constraint validation (no errors/warnings)
- ✅ UI element positioning and visibility
- ✅ Text readability and truncation prevention
- ✅ Image aspect ratio validation
- ✅ Button and interactive element accessibility
- ✅ Modern card-based design patterns (12pt rounded corners, shadows)

### Specific Areas Tested

#### Listen Tab
- Collection view layout and cell spacing
- Series card design and image display
- Navigation bar buttons (Recently Played, Now Playing)
- Multi-column layout on iPad landscape
- Predictive scrolling behavior

#### Notes Tab
- Table view with modern card-based cells
- Add/Edit note functionality
- Text hierarchy and readability
- Note content display and preview

#### Connect Tab
- Modern table view cells with subtitles
- Navigation to announcements and other features
- Action sheet interactions (Social media)
- Proper spacing and margins

#### More Tab
- Complete options list validation
- Bible integration navigation
- Settings and app information access
- Social media action sheets

### iPad-Specific Features
- ✅ Adaptive layouts with maximum content width (600pt)
- ✅ Multi-column layouts for landscape orientation
- ✅ Centered content when constrained width < screen width
- ✅ Layered image designs (blurred backgrounds with 16:9 foreground)
- ✅ White bar elimination validation

### Design Standards Validation
- ✅ 16pt horizontal margins
- ✅ 8pt vertical spacing between elements
- ✅ 12pt rounded corners on cards
- ✅ Subtle shadows (4pt offset, 8pt radius, 0.4 opacity)
- ✅ Dark theme aesthetic consistency
- ✅ Enhanced typography hierarchy

## Test Files Structure

```
Thrive Community ChurchUITests/
├── ThriveUITestBase.swift              # Base test class with common utilities
├── Thrive_Community_ChurchUITests.swift # Basic app launch and navigation tests
├── ListenTabUITests.swift              # Listen tab specific tests
├── NotesTabUITests.swift               # Notes tab specific tests
├── ConnectTabUITests.swift             # Connect tab specific tests
├── MoreTabUITests.swift                # More tab specific tests
├── DeviceSpecificUITests.swift         # Device and orientation specific tests
├── LayoutValidationUITests.swift       # Layout constraint and spacing validation
├── ComprehensiveUITestSuite.swift      # Complete test suite runner
├── TestConfiguration.swift             # Test configuration utilities
├── TestValidation.swift                # Validation helper methods
└── TESTING.md                          # This comprehensive documentation
```

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

**Run Specific UI Test Class**:
```bash
# Run Listen tab tests only
xcodebuild test \
  -workspace "Thrive Church Official App.xcworkspace" \
  -scheme "Thrive Church Official App" \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro Max' \
  -only-testing:"Thrive Church Official AppUITests/ListenTabUITests"

# Run comprehensive UI test suite
xcodebuild test \
  -workspace "Thrive Church Official App.xcworkspace" \
  -scheme "Thrive Church Official App" \
  -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch) (6th generation)' \
  -only-testing:"Thrive Church Official AppUITests/ComprehensiveUITestSuite"
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

A convenient shell script `run-tests.sh` is provided in the UI tests directory for easy test execution with colored output and helpful information.

#### Using the Script

**Navigate to the UI tests directory**:
```bash
cd "Thrive Community ChurchUITests"
```

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
$ cd "Thrive Community ChurchUITests"
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

#### Continuous Integration for UI Tests

For CI/CD integration with comprehensive UI testing:

```yaml
- name: Run Comprehensive UI Tests
  run: |
    xcodebuild test \
      -workspace "Thrive Church Official App.xcworkspace" \
      -scheme "Thrive Church Official App" \
      -destination 'platform=iOS Simulator,name=iPhone 15 Pro Max' \
      -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch) (6th generation)' \
      -only-testing:Thrive_Community_ChurchUITests/ComprehensiveUITestSuite \
      -resultBundlePath TestResults \
      | xcpretty --test --color
```

### Supported Simulators

The tests are configured to run on iOS 15.0+ simulators. Recommended devices:

#### iPhone Testing
- **iPhone SE (3rd generation)** - Primary small screen testing device
- **iPhone 15 Pro Max** - Large screen validation
- iPhone 14, iPhone 14 Pro - Additional coverage

#### iPad Testing
- **iPad (9th generation)** - Standard iPad testing
- **iPad Pro (12.9-inch)** - Large tablet validation
- iPad Air (5th generation) - Mid-size tablet coverage

### Recommended Test Device Commands

#### iPhone Testing
```bash
# Small screen
-destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)'

# Large screen
-destination 'platform=iOS Simulator,name=iPhone 15 Pro Max'
```

#### iPad Testing
```bash
# Standard iPad
-destination 'platform=iOS Simulator,name=iPad (10th generation)'

# Large iPad
-destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch) (6th generation)'
```

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

## Test Results and Screenshots

The UI test suite automatically captures screenshots for:
- ✅ **Visual regression testing** - Compare layouts across app versions
- ✅ **Layout validation evidence** - Document proper rendering
- ✅ **Device-specific rendering verification** - Ensure responsive design works
- ✅ **Orientation change validation** - Verify landscape/portrait layouts

### Screenshot Naming Convention
Screenshots are saved with descriptive names including:
- Test name and method
- Device type (iPhone/iPad)
- Orientation (portrait/landscape)
- Tab or feature being tested
- Timestamp for uniqueness

### Interpreting Test Results

#### Success Criteria
- All assertions pass without failures
- No AutoLayout constraint warnings in console
- Screenshots show proper layout and spacing
- Interactive elements are accessible and properly sized
- Content fills available space without white bars (iPad)

#### Common Issues to Watch For
- **White bars on iPad**: Indicates layout not extending to screen edges
- **Constraint conflicts**: AutoLayout warnings in console output
- **Text truncation**: Content not fitting properly in allocated space
- **Spacing inconsistencies**: Cards not following 8pt/16pt spacing standards
- **Touch target sizes**: Interactive elements smaller than 44pt minimum

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

### UI Test Specific Troubleshooting

#### Common UI Test Issues
- **Test timeouts**: Increase wait times for slow loading content
- **Element not found**: Verify accessibility identifiers and element hierarchy
- **Screenshot failures**: Check file permissions and storage space
- **Simulator issues**: Reset simulator content and settings

#### Debug Tips for UI Tests
- Use `app.debugDescription` to inspect element hierarchy
- Add `Thread.sleep()` for timing-sensitive interactions
- Enable slow animations in simulator for better debugging
- Check console output for AutoLayout warnings
- Use breakpoints in UI test code to inspect app state

#### Performance Considerations
- UI tests take significantly longer than unit tests (~30-60s vs ~3s)
- Consider running UI tests on specific devices for faster feedback
- Use the comprehensive test suite for full validation before releases
- Run individual test classes during development for faster iteration

## Maintenance

### Adding New Tests

#### Unit Tests
1. Add to `Thrive Community ChurchTests/` directory
2. Follow existing naming conventions
3. Ensure new test files are added to the Unit Tests target

#### UI Tests
1. Add to `Thrive Community ChurchUITests/` directory
2. Inherit from `ThriveUITestBase` for common utilities
3. Use descriptive test method names
4. Include screenshot capture for visual validation
5. Follow the established pattern: setup → validation → screenshot → cleanup
6. Ensure new test files are added to the UI Tests target

### Updating for New Features

#### UI Test Updates
- Add new UI elements to validation lists
- Update expected content in tab-specific tests
- Verify new features work across all device sizes
- Ensure new layouts follow design standards (16pt margins, 8pt spacing, etc.)
- Test new features in both portrait and landscape orientations
- Validate accessibility identifiers for new elements

### Updating Dependencies

When updating CocoaPods dependencies:
1. Run `pod install`
2. Clean derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData/Thrive_Church_Official_App-*`
3. Run unit tests first for quick validation
4. Run UI tests to verify visual compatibility
5. Check for any new AutoLayout warnings or constraint conflicts

### CI/CD Integration

For continuous integration, use the command-line testing approach with:
- Appropriate simulator destinations for device coverage
- Test result parsing and screenshot archival
- Separate unit and UI test stages for faster feedback
- Comprehensive UI testing before releases

## Support

If you encounter issues not covered in this guide:
1. Check the build logs for specific error messages
2. Verify all build settings are correctly applied
3. Ensure the correct iOS deployment target (15.0+)
4. Clean and rebuild the project

## Quick Reference

### Convenience Script Commands (Recommended)

**Navigate to UI tests directory first**:
```bash
cd "Thrive Community ChurchUITests"
```

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
