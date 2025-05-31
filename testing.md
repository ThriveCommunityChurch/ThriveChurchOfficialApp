# Testing Scripts and Utilities

This document covers the root-level testing scripts and utilities for the Thrive Church Official App project.

## 📁 Testing Script Overview

The project includes several testing scripts in the root directory:

- **`run-tests.sh`** - Main testing convenience script for local development
- **`run_tests_ci.sh`** - CI-specific testing script for automated environments
- **`run_build.sh`** - Build-only script for compilation verification

## 🚀 Main Testing Script: `run-tests.sh`

### Purpose
A convenient wrapper script for running tests locally with colored output and helpful information.

### Usage
```bash
./run-tests.sh [command]
```

### Available Commands

| Command | Description | Duration |
|---------|-------------|----------|
| `unit` | Run unit tests only | ~3 seconds |
| `ui` | Run UI tests only | ~30-60 seconds |
| `all` | Run all tests (default) | ~30-60 seconds |
| `clean` | Clean build environment | ~10 seconds |
| `help` | Show usage information | Instant |

### Examples

**Run unit tests** (fastest feedback):
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

**Clean environment before testing**:
```bash
./run-tests.sh clean
```

### Script Features

- ✅ **Colored output** - Green for success, red for errors, blue for info
- ✅ **Time estimates** - Shows expected duration for each test type
- ✅ **Error handling** - Graceful handling of known issues
- ✅ **Progress indicators** - Clear status messages throughout execution
- ✅ **Automatic validation** - Checks workspace exists before running
- ✅ **Flexible location** - Can be run from project root or UI tests directory

### Script Configuration

The script automatically detects its location and configures paths:

```bash
# Configuration
SCHEME='Thrive Church Official App'
WORKSPACE='Thrive Church Official App.xcworkspace'
DESTINATION='platform=iOS Simulator,name=iPhone SE (3rd generation)'
UNIT_TESTS='Thrive Church Official AppTests'
UI_TESTS='Thrive Church Official AppUITests'
```

## 🔧 CI Testing Script: `run_tests_ci.sh`

### Purpose
Specialized script for continuous integration environments with CI-specific configurations.

### Key Features

- **Dummy file creation** - Creates placeholder config files for CI
- **Simulator detection** - Smart iOS simulator selection for CI environments
- **Timeout configuration** - Extended timeouts for CI stability
- **Result handling** - Treats UI test failures as warnings, not hard failures

### CI-Specific Behavior

1. **Creates dummy Config.plist**:
   ```xml
   <key>APIUrl</key>
   <string>httpbin.org</string>
   <key>ESVApiKey</key>
   <string>dummy-esv-key</string>
   ```

2. **Creates dummy GoogleService-Info.plist** for Firebase

3. **Uses specific simulator**: iPhone 15 iOS 17.5 (CI default)

4. **Extended timeouts**:
   - Default execution time: 300 seconds
   - Maximum execution time: 600 seconds

### Usage in CI
```bash
# Called automatically by GitHub Actions
./run_tests_ci.sh
```

## 🏗️ Build Script: `run_build.sh`

### Purpose
Compilation-only script for verifying the project builds without running tests.

### Usage
```bash
./run_build.sh
```

### Features
- Creates dummy config files if needed
- Installs CocoaPods dependencies
- Performs build verification
- Faster than full test runs

## 📋 Script Comparison

| Feature | `run-tests.sh` | `run_tests_ci.sh` | `run_build.sh` |
|---------|----------------|-------------------|----------------|
| **Purpose** | Local development | CI/CD automation | Build verification |
| **Test Types** | Unit + UI | Comprehensive UI | None (build only) |
| **Duration** | 3s - 60s | 60s - 300s | 10s - 30s |
| **Config Files** | Uses existing | Creates dummy | Creates dummy |
| **Error Handling** | Hard failures | Warnings for UI | Hard failures |
| **Simulator** | Auto-detect | Fixed (iPhone 15) | N/A |

## 🛠️ Script Maintenance

### Making Scripts Executable
```bash
chmod +x run-tests.sh
chmod +x run_tests_ci.sh
chmod +x run_build.sh
```

### Script Locations
The `run-tests.sh` script exists in two locations:
- **Root directory**: `./run-tests.sh`
- **UI Tests directory**: `./Thrive Community ChurchUITests/run-tests.sh`

Both are identical and can be run from either location.

### Updating Scripts

When modifying scripts:
1. **Test locally first** with `./run-tests.sh`
2. **Verify CI compatibility** by checking CI environment variables
3. **Update both copies** of `run-tests.sh` if needed
4. **Test in CI** with a pull request

## 🔍 Troubleshooting Scripts

### Common Issues

#### 1. Permission Denied
```bash
# Error: Permission denied
chmod +x run-tests.sh
```

#### 2. Workspace Not Found
```bash
# Error: Workspace not found
# Solution: Run from project root or check workspace name
ls -la "Thrive Church Official App.xcworkspace"
```

#### 3. Simulator Not Available
```bash
# Error: Simulator not found
# Solution: Check available simulators
xcrun simctl list devices available
```

#### 4. CocoaPods Issues
```bash
# Error: Pod install failed
# Solution: Update CocoaPods and dependencies
sudo gem install cocoapods
pod install --repo-update
```

### Debug Mode

For verbose output, modify the script temporarily:
```bash
# Add to script for debugging
set -x  # Enable debug mode
set -e  # Exit on error
```

## 📊 Script Output Examples

### Successful Unit Test Run
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

### Failed Test Run
```bash
$ ./run-tests.sh ui
========================================
  Thrive Church Official App - Tests
========================================
ℹ️  Running UI tests...
Expected: ~30-60 seconds, 90+ tests

[Build output...]

❌ UI tests failed!
```

## 🔗 Related Documentation

- **[Unit Tests](Thrive%20Community%20ChurchTests/README.md)** - Unit test documentation
- **[UI Tests](Thrive%20Community%20ChurchUITests/TESTING.md)** - Comprehensive UI test guide
- **[CI/CD Testing](ci_testing.md)** - Continuous integration documentation
- **[Contributing](CONTRIBUTING.md)** - Contribution guidelines including testing requirements

## 📝 Best Practices

### Local Development
1. **Run unit tests first** for quick feedback
2. **Use `clean` command** when switching branches
3. **Run full test suite** before committing
4. **Check script output** for warnings or issues

### Script Modifications
1. **Test changes locally** before committing
2. **Maintain backward compatibility** when possible
3. **Update documentation** when adding features
4. **Consider CI impact** of script changes

