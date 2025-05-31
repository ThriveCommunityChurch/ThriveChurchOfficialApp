# CI/CD Testing Documentation

This document covers the continuous integration and automated testing setup for the Thrive Church Official App.

## 🔄 CI/CD Overview

The project uses **GitHub Actions** for continuous integration with separate workflows for building and testing.

### Workflow Files
- **`.github/workflows/build.yml`** - Build verification workflow
- **`.github/workflows/test.yml`** - Comprehensive testing workflow

### Trigger Events
Both workflows trigger on:
- **Pull Requests** to `master` and `dev` branches
- **Manual dispatch** via GitHub Actions UI

## 🏗️ Build Workflow

### Purpose
Verifies that the project compiles successfully without running tests.

### Configuration
```yaml
name: Build
on:
  workflow_dispatch:
  pull_request:
    branches: [ "master", "dev" ]

jobs:
  build:
    runs-on: macos-latest
    steps:
      - name: Checkout
      - name: Select Xcode 16
      - name: Install CocoaPods
      - name: Run build script
```

### Build Script: `run_build.sh`
- Creates dummy configuration files for CI
- Installs CocoaPods dependencies
- Performs compilation verification
- Duration: ~10-30 seconds

## 🧪 Test Workflow

### Purpose
Runs comprehensive test suite including unit and UI tests.

### Configuration
```yaml
name: Test
on:
  workflow_dispatch:
  pull_request:
    branches: [ "master", "dev" ]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - name: Checkout
      - name: Select Xcode 16
      - name: Install CocoaPods
      - name: Run tests (critical tests must pass, UI tests are informational)
      - name: Upload test results
```

### Test Script: `run_tests_ci.sh`
- Creates dummy configuration files
- Runs comprehensive UI test suite (90+ tests)
- Treats UI test failures as warnings
- Duration: ~60-300 seconds

## 🎯 Test Strategy

### Critical Tests (Must Pass)
Currently, unit tests are skipped as they contain only placeholder implementations:
```bash
echo "⏭️  Skipping Unit Tests (no meaningful tests implemented)"
```

### Informational Tests (Warnings Only)
UI tests run comprehensively but failures don't block CI:
```bash
echo "🖥️ Running Comprehensive UI Test Suite (All 90+ Tests)"
echo "ℹ️  Note: Test failures will be treated as warnings only"
```

### Test Coverage
- **Unit Tests**: 2 placeholder tests (skipped in CI)
- **UI Tests**: 90+ comprehensive tests across all tabs and devices
- **Device Coverage**: iPhone and iPad simulators
- **Orientation Testing**: Portrait and landscape validation

## 🔧 CI Environment Configuration

### Xcode Version
- **Xcode 16.1** - Selected via `xcode-select`
- **iOS Simulator**: iPhone 15 iOS 17.5 (CI default)

### Dummy Configuration Files

#### Config.plist
```xml
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
    <key>APIUrl</key>
    <string>httpbin.org</string>
    <key>ESVApiKey</key>
    <string>dummy-esv-key</string>
</dict>
</plist>
```

#### GoogleService-Info.plist
```xml
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
    <key>BUNDLE_ID</key>
    <string>com.thrive-fl.ThriveCommunityChurch</string>
    <key>PROJECT_ID</key>
    <string>dummy-project</string>
    <!-- Additional dummy Firebase configuration -->
</dict>
</plist>
```

### Dependencies
- **CocoaPods**: Installed via `sudo gem install cocoapods`
- **Pod Install**: Run with `--repo-update` for CI reliability

## ⚙️ CI-Specific Settings

### Test Timeouts
Extended timeouts for CI stability:
```bash
-test-timeouts-enabled YES
-default-test-execution-time-allowance 300
-maximum-test-execution-time-allowance 600
```

### Build Settings
```bash
CODE_SIGNING_ALLOWED='NO'
ENABLE_TESTABILITY=YES
CI=true
```

### Simulator Configuration
```bash
# CI environment detection
if [ "$CI" = "true" ]; then
    DESTINATION="platform=iOS Simulator,name=iPhone 15,OS=17.5"
else
    # Local development uses smart detection
fi
```

## 📊 Test Results and Artifacts

### Test Result Upload
```yaml
- name: Upload test results
  uses: actions/upload-artifact@v4
  if: always()
  with:
    name: test-results
    path: |
      *.xcresult
      TestResults/
```

### Result Processing
- **Success**: All critical tests pass (currently none)
- **Warning**: UI test failures are logged but don't fail CI
- **Failure**: Build failures or critical test failures

### Output Filtering
CI script filters out confusing "TEST FAILED" messages:
```bash
grep -v "^\*\* TEST FAILED \*\*$" || true
```

## 🔍 Monitoring and Debugging

### CI Logs
Access detailed logs through:
1. **GitHub Actions tab** in the repository
2. **Pull Request checks** section
3. **Workflow run details** for specific steps

### Common CI Issues

#### 1. Simulator Availability
**Issue**: Simulator not found in CI
**Solution**: Use fixed simulator configuration for CI

#### 2. Timeout Issues
**Issue**: Tests timeout in CI environment
**Solution**: Extended timeout configuration applied

#### 3. Framework Loading
**Issue**: CocoaPods frameworks not loading
**Solution**: Proper inheritance configuration in Podfile

#### 4. Configuration Files Missing
**Issue**: Missing Config.plist or GoogleService-Info.plist
**Solution**: Automatic dummy file creation in CI

### Debugging CI Failures

1. **Check build logs** for specific error messages
2. **Verify simulator availability** in CI environment
3. **Review timeout settings** for long-running tests
4. **Validate dummy configuration files** are created correctly

## 🚀 CI Performance Optimization

### Build Caching
- **CocoaPods**: Dependencies cached between runs
- **Derived Data**: Cleaned for consistent builds
- **Simulator**: Reused when possible

### Parallel Execution
- **Build and Test**: Separate workflows for faster feedback
- **Concurrency**: Cancel in-progress runs for new commits

### Resource Management
```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

## 📋 CI Workflow Status

### Current Status
- ✅ **Build Workflow**: Fully functional
- ✅ **Test Workflow**: Functional with informational UI tests
- ⚠️ **Unit Tests**: Skipped (placeholder implementations)
- ✅ **UI Tests**: Comprehensive coverage (warnings only)

### Success Criteria
- **Build**: Project compiles successfully
- **Critical Tests**: None currently (unit tests are placeholders)
- **UI Tests**: Run for validation but don't block merges

## 🔮 Future Improvements

### Immediate Priorities
1. **Implement meaningful unit tests** to enable critical test validation
2. **Add test result parsing** for better CI reporting
3. **Implement test coverage reporting** for code quality metrics

### Long-term Goals
- **Matrix testing** across multiple iOS versions
- **Device-specific test runs** for comprehensive coverage
- **Performance regression testing** in CI
- **Automated screenshot comparison** for UI validation

## 🛠️ Modifying CI Configuration

### Updating Workflows
1. **Edit workflow files** in `.github/workflows/`
2. **Test changes** in a feature branch first
3. **Monitor CI runs** for any issues
4. **Update documentation** when making changes

### Adding New Tests
1. **Add tests** to appropriate test targets
2. **Update CI scripts** if needed
3. **Verify CI compatibility** with new test requirements
4. **Document changes** in relevant README files

### Changing Test Strategy
1. **Update `run_tests_ci.sh`** for new test configurations
2. **Modify workflow files** if needed
3. **Test thoroughly** before merging
4. **Communicate changes** to the development team

## 📞 Support and Troubleshooting

### Getting Help
1. **Check CI logs** for specific error messages
2. **Review this documentation** for common issues
3. **Test locally** using `./run_tests_ci.sh` (with CI=true)
4. **Consult GitHub Actions documentation** for workflow issues

### Reporting CI Issues
When reporting CI problems:
1. **Include workflow run URL**
2. **Provide error messages** from logs
3. **Specify branch** and commit hash
4. **Describe expected vs actual behavior**
