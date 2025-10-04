# Unit Tests - Thrive Church Official App

## Overview

This directory contains the unit test suite for the Thrive Church Official App. Unit tests focus on testing individual components, business logic, and data models in isolation.

## Current Test Status

- **Test Target**: `Thrive Church Official AppTests`
- **Test Count**: 2 tests
- **Status**: ✅ All tests passing
- **Execution Time**: ~3 seconds

### Test Files

- **`Thrive_Community_ChurchTests.swift`** - Main test file containing basic unit tests

### Current Tests

1. **`testExample`** - ✅ Basic example test (placeholder)
2. **`testPerformanceExample`** - ✅ Performance testing example (placeholder)

## Running Unit Tests

### Method 1: Xcode IDE
1. Open `Thrive Church Official App.xcworkspace`
2. Press `Cmd+6` to open Test Navigator
3. Click the play button next to `Thrive Church Official AppTests`
4. Or use `Cmd+U` to run all tests

### Method 2: Command Line
```bash
# From project root
xcodebuild test \
  -workspace "Thrive Church Official App.xcworkspace" \
  -scheme "Thrive Church Official App" \
  -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)' \
  -only-testing:"Thrive Church Official AppTests"
```

### Method 3: Convenience Script
```bash
# From project root
./run-tests.sh unit
```

## Test Configuration

### Build Settings
- **Swift Module Name**: `Thrive_Church_Official_AppTests`
- **Bundle Type**: `mh_bundle`
- **Swift Install Objc Header**: `NO`

### Dependencies
- Inherits from main app target
- Uses CocoaPods dependencies via `:complete` inheritance

## Adding New Unit Tests

### 1. Create Test Files
Add new Swift test files to this directory following the naming convention:
- `[FeatureName]Tests.swift`
- `[ComponentName]UnitTests.swift`

### 2. Test Structure
```swift
import XCTest
@testable import Thrive_Community_Church

class YourFeatureTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Setup code before each test
    }
    
    override func tearDownWithError() throws {
        // Cleanup code after each test
    }
    
    func testYourFeature() throws {
        // Your test implementation
        XCTAssertTrue(true, "Test should pass")
    }
    
    func testPerformanceExample() throws {
        measure {
            // Performance testing code
        }
    }
}
```

### 3. Target Membership
Ensure new test files are added to the `Thrive Church Official AppTests` target.

## Recommended Test Areas

The following areas would benefit from comprehensive unit testing:

### Data Models
- **SermonMessage** - Message parsing and validation
- **SermonSeries** - Series data handling
- **Note** - Note creation and management
- **Configuration** - Config.plist parsing

### Extensions
- **StringExtensions** - String manipulation utilities
- **TimestampExtension** - Date/time formatting
- **UIColorExtension** - Color utilities
- **DataExtension** - Data conversion methods

### Business Logic
- **Storage** - Local data persistence
- **Network** - API communication (with mocking)
- **Audio Player** - Playback logic
- **Download Manager** - File download handling

### Utilities
- **ApplicationVariables** - Constants and cache keys
- **ConfigurationExtension** - Configuration management
- **Reachability** - Network status detection

## Testing Best Practices

### 1. Test Naming
- Use descriptive test method names
- Follow pattern: `test[WhatYouAreTesting][ExpectedResult]`
- Example: `testSermonMessageParsing_ValidJSON_ReturnsCorrectMessage`

### 2. Test Organization
- Group related tests in the same test class
- Use `setUp()` and `tearDown()` for common test preparation
- Keep tests independent and isolated

### 3. Assertions
- Use appropriate XCTest assertions
- Provide meaningful failure messages
- Test both success and failure cases

### 4. Mocking
- Mock external dependencies (network, file system)
- Use dependency injection for testability
- Avoid testing implementation details

## Performance Testing

### Guidelines
- Use `measure` blocks for performance tests
- Set reasonable performance baselines
- Test critical paths (data parsing, UI updates)

### Example
```swift
func testSermonMessageParsingPerformance() throws {
    let jsonData = // ... large JSON data
    
    measure {
        let messages = try JSONDecoder().decode([SermonMessage].self, from: jsonData)
        XCTAssertFalse(messages.isEmpty)
    }
}
```

## Troubleshooting

### Common Issues

#### 1. Module Import Errors
**Error**: `No such module 'Thrive_Community_Church'`
**Solution**: Ensure the main app builds successfully first

#### 2. Test Target Not Found
**Error**: Test target not recognized
**Solution**: Clean derived data and rebuild:
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/Thrive_Church_Official_App-*
```

#### 3. CocoaPods Framework Issues
**Error**: Framework loading errors
**Solution**: Ensure Podfile inheritance is correct and run `pod install`

### Build Configuration
If you encounter Swift module conflicts, verify these settings:
- `SWIFT_INSTALL_OBJC_HEADER = NO`
- `SWIFT_MODULE_NAME = Thrive_Church_Official_AppTests`
- `MACH_O_TYPE = mh_bundle`

## CI/CD Integration

Unit tests are integrated into the CI/CD pipeline:
- Run automatically on pull requests
- Must pass for merge approval
- Provide fast feedback (~3 seconds)

See [`../ci_testing.md`](../ci_testing.md) for CI configuration details.

## Future Improvements

### Immediate Priorities
1. **Replace placeholder tests** with meaningful unit tests
2. **Add data model tests** for SermonMessage and SermonSeries
3. **Test configuration parsing** and error handling
4. **Add network layer tests** with proper mocking

### Long-term Goals
- Achieve 80%+ code coverage for business logic
- Add property-based testing for data validation
- Implement snapshot testing for data structures
- Add integration tests for critical user flows

## Support

For unit testing questions or issues:
1. Check this documentation first
2. Review existing test patterns in the codebase
3. Consult the main project [README.md](../README.md)
4. See [CI testing documentation](../ci_testing.md) for automated testing
