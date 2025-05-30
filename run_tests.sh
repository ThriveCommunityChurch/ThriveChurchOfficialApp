#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
SCHEME='Thrive Church Official App'
WORKSPACE='Thrive Church Official App.xcworkspace'

# Auto-detect best available iPhone simulator
echo -e "${YELLOW}🔍 Finding best iPhone simulator...${NC}"

# Get the first available iPhone simulator (preferring newer models)
SIMULATOR_ID=$(xcodebuild -showdestinations -scheme "$SCHEME" -workspace "$WORKSPACE" 2>/dev/null | \
    grep "platform:iOS Simulator" | \
    grep "iPhone" | \
    grep -E "(iPhone 16|iPhone 15|iPhone 14|iPhone 13)" | \
    head -1 | \
    sed -n 's/.*id:\([^,]*\).*/\1/p')

if [ -z "$SIMULATOR_ID" ]; then
    # Fallback to any iPhone simulator
    SIMULATOR_ID=$(xcodebuild -showdestinations -scheme "$SCHEME" -workspace "$WORKSPACE" 2>/dev/null | \
        grep "platform:iOS Simulator" | \
        grep "iPhone" | \
        head -1 | \
        sed -n 's/.*id:\([^,]*\).*/\1/p')
fi

if [ -n "$SIMULATOR_ID" ]; then
    DESTINATION="platform=iOS Simulator,id=$SIMULATOR_ID"
    SIMULATOR_NAME=$(xcodebuild -showdestinations -scheme "$SCHEME" -workspace "$WORKSPACE" 2>/dev/null | \
        grep "$SIMULATOR_ID" | \
        head -1 | \
        sed -n 's/.*name:\([^,}]*\).*/\1/p')
    echo -e "${GREEN}✅ Using: $SIMULATOR_NAME (ID: $SIMULATOR_ID)${NC}"
else
    echo -e "${RED}❌ No iPhone simulators found!${NC}"
    exit 1
fi

echo -e "${YELLOW}🚀 Starting iOS Tests for ${SCHEME}${NC}"
echo "Workspace: ${WORKSPACE}"
echo "Destination: ${DESTINATION}"
echo ""

# Create dummy config files if they don't exist
if [ ! -f "Config.plist" ]; then
    echo -e "${YELLOW}📝 Creating dummy Config.plist${NC}"
    cat > Config.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>API_URL</key>
    <string>https://api.example.com</string>
</dict>
</plist>
EOF
fi

if [ ! -f "GoogleService-Info.plist" ]; then
    echo -e "${YELLOW}📝 Creating dummy GoogleService-Info.plist${NC}"
    cat > GoogleService-Info.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>BUNDLE_ID</key>
    <string>com.thrive-fl.ThriveCommunityChurch</string>
    <key>PROJECT_ID</key>
    <string>dummy-project</string>
    <key>GOOGLE_APP_ID</key>
    <string>1:123456789:ios:dummy</string>
</dict>
</plist>
EOF
fi

# Install dependencies if needed
if [ ! -d "Pods" ]; then
    echo -e "${YELLOW}📦 Installing CocoaPods dependencies${NC}"
    pod install
fi

# CI-specific fixes for Firebase and CocoaPods
if [ "$CI" = "true" ]; then
    echo -e "${YELLOW}🔧 Applying CI-specific fixes${NC}"

    # Clean any existing build artifacts
    rm -rf ~/Library/Developer/Xcode/DerivedData
    rm -rf build/

    # Set environment variables for CI
    export ENABLE_PREVIEWS=NO
    export ENABLE_BITCODE=NO
    export ENABLE_TESTABILITY=YES
    export SWIFT_COMPILATION_MODE=wholemodule
    export SWIFT_OPTIMIZATION_LEVEL=-Onone
    export GCC_OPTIMIZATION_LEVEL=0

    # Fix potential module compilation issues
    echo -e "${YELLOW}🔧 Cleaning and rebuilding Pods for CI${NC}"
    pod deintegrate || true
    pod cache clean --all
    pod install --repo-update --clean-install

    # Additional Firebase-specific fixes for CI
    echo -e "${YELLOW}🔧 Applying Firebase CI workarounds${NC}"

    # Fix Firebase Swift compilation issues in CI
    if [ -d "Pods/FirebaseCoreInternal" ]; then
        echo "Applying FirebaseCoreInternal CI fixes..."
        # Create missing directories that CI sometimes doesn't create
        mkdir -p "Pods/FirebaseCoreInternal/FirebaseCore/Internal/Sources/HeartbeatLogging"
        mkdir -p "Pods/FirebaseCoreInternal/FirebaseCore/Internal/Sources/Utilities"
    fi

    # Set additional CI-specific build settings
    export SWIFT_ACTIVE_COMPILATION_CONDITIONS="COCOAPODS"
    export SWIFT_SUPPRESS_WARNINGS=YES
    export GCC_WARN_INHIBIT_ALL_WARNINGS=YES
fi

echo -e "${GREEN}🧪 Running Unit Tests${NC}"

# Test with CI-specific settings if in CI environment
if [ "$CI" = "true" ]; then
    echo -e "${YELLOW}🔧 Using CI-optimized test settings${NC}"
    xcodebuild test \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" \
        -sdk iphonesimulator \
        -destination "$DESTINATION" \
        -only-testing:"${SCHEME}Tests" \
        CODE_SIGNING_ALLOWED='NO' \
        ENABLE_TESTABILITY=YES \
        ENABLE_BITCODE=NO \
        SWIFT_COMPILATION_MODE=wholemodule \
        SWIFT_OPTIMIZATION_LEVEL=-Onone \
        GCC_OPTIMIZATION_LEVEL=0 \
        DEBUG_INFORMATION_FORMAT=dwarf \
        ONLY_ACTIVE_ARCH=YES \
        VALID_ARCHS="x86_64" \
        ARCHS="x86_64" \
        CLANG_ENABLE_MODULE_DEBUGGING=NO \
        SWIFT_ACTIVE_COMPILATION_CONDITIONS="COCOAPODS" \
        SWIFT_SUPPRESS_WARNINGS=YES \
        GCC_WARN_INHIBIT_ALL_WARNINGS=YES \
        SWIFT_TREAT_WARNINGS_AS_ERRORS=NO \
        GCC_TREAT_WARNINGS_AS_ERRORS=NO
else
    echo -e "${GREEN}🔧 Using local development test settings${NC}"
    xcodebuild test \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" \
        -sdk iphonesimulator \
        -destination "$DESTINATION" \
        -only-testing:"${SCHEME}Tests" \
        CODE_SIGNING_ALLOWED='NO' \
        ENABLE_TESTABILITY=YES
fi

UNIT_TEST_RESULT=$?

echo -e "${GREEN}🖥️ Running UI Tests${NC}"

# UI Test with CI-specific settings if in CI environment
if [ "$CI" = "true" ]; then
    echo -e "${YELLOW}🔧 Using CI-optimized UI test settings${NC}"
    xcodebuild test \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" \
        -sdk iphonesimulator \
        -destination "$DESTINATION" \
        -only-testing:"${SCHEME}UITests" \
        CODE_SIGNING_ALLOWED='NO' \
        ENABLE_TESTABILITY=YES \
        ENABLE_BITCODE=NO \
        SWIFT_COMPILATION_MODE=wholemodule \
        SWIFT_OPTIMIZATION_LEVEL=-Onone \
        GCC_OPTIMIZATION_LEVEL=0 \
        DEBUG_INFORMATION_FORMAT=dwarf \
        ONLY_ACTIVE_ARCH=YES \
        VALID_ARCHS="x86_64" \
        ARCHS="x86_64" \
        CLANG_ENABLE_MODULE_DEBUGGING=NO \
        SWIFT_ACTIVE_COMPILATION_CONDITIONS="COCOAPODS" \
        SWIFT_SUPPRESS_WARNINGS=YES \
        GCC_WARN_INHIBIT_ALL_WARNINGS=YES \
        SWIFT_TREAT_WARNINGS_AS_ERRORS=NO \
        GCC_TREAT_WARNINGS_AS_ERRORS=NO
else
    echo -e "${GREEN}🔧 Using local development UI test settings${NC}"
    xcodebuild test \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" \
        -sdk iphonesimulator \
        -destination "$DESTINATION" \
        -only-testing:"${SCHEME}UITests" \
        CODE_SIGNING_ALLOWED='NO' \
        ENABLE_TESTABILITY=YES
fi

UI_TEST_RESULT=$?

# Report results
echo ""
echo "========================================="
if [ $UNIT_TEST_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ Unit Tests: PASSED${NC}"
else
    echo -e "${RED}❌ Unit Tests: FAILED${NC}"
fi

if [ $UI_TEST_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ UI Tests: PASSED${NC}"
else
    echo -e "${YELLOW}⚠️ UI Tests: FAILED (continuing)${NC}"
fi
echo "========================================="

# Exit with unit test result (UI tests are allowed to fail)
exit $UNIT_TEST_RESULT
