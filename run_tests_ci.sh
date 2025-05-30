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

# CI-specific simulator detection
if [ "$CI" = "true" ]; then
    echo -e "${YELLOW}🔧 CI environment - using simple simulator detection${NC}"
    # In CI, use a specific OS version that's available
    # From the CI logs, iPhone 15 is available with OS:17.5
    DESTINATION="platform=iOS Simulator,name=iPhone 15,OS=17.5"
    echo -e "${GREEN}✅ Using: iPhone 15 iOS 17.5 (CI default)${NC}"
else
    # Local development - use smart detection
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
        echo -e "${RED}❌ No iPhone simulators found! Falling back to default${NC}"
        DESTINATION="platform=iOS Simulator,name=iPhone 15,OS=17.5"
        echo -e "${YELLOW}⚠️ Using fallback: iPhone 15 iOS 17.5${NC}"
    fi
fi

echo -e "${YELLOW}🚀 Starting iOS Tests for ${SCHEME}${NC}"
echo "Workspace: ${WORKSPACE}"
echo "Destination: ${DESTINATION}"
echo ""

# Create dummy config files if they don't exist (BEFORE any builds)
# Only create dummy files in CI environment to avoid overwriting local files
if [ "$CI" = "true" ]; then
    echo -e "${YELLOW}📝 Creating dummy Config.plist for CI${NC}"
    cat > Config.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>APIUrl</key>
    <string>httpbin.org</string>
    <key>ESVApiKey</key>
    <string>dummy-esv-key</string>
</dict>
</plist>
EOF
else
    echo -e "${GREEN}✅ Using existing Config.plist (local development)${NC}"
fi

if [ "$CI" = "true" ]; then
    echo -e "${YELLOW}📝 Creating dummy GoogleService-Info.plist for CI${NC}"
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
    <key>API_KEY</key>
    <string>dummy-api-key</string>
    <key>GCM_SENDER_ID</key>
    <string>123456789</string>
</dict>
</plist>
EOF
else
    echo -e "${GREEN}✅ Using existing GoogleService-Info.plist (local development)${NC}"
fi

# Install dependencies if needed
if [ ! -d "Pods" ]; then
    echo -e "${YELLOW}📦 Installing CocoaPods dependencies${NC}"
    pod install
fi

# CI-specific setup
if [ "$CI" = "true" ]; then
    echo -e "${YELLOW}🔧 CI environment detected${NC}"

    # Ensure pods are up to date in CI
    echo -e "${YELLOW}🔧 Installing/updating Pods${NC}"
    pod install --repo-update
fi

# CRITICAL TESTS (Must pass - will fail CI)
echo -e "${GREEN}🧪 Running Critical Tests (Unit Tests)${NC}"
xcodebuild test \
    -workspace "$WORKSPACE" \
    -scheme "$SCHEME" \
    -sdk iphonesimulator \
    -destination "$DESTINATION" \
    -only-testing:"${SCHEME}Tests" \
    CODE_SIGNING_ALLOWED='NO' \
    ENABLE_TESTABILITY=YES

CRITICAL_TEST_RESULT=$?

# INFORMATIONAL TESTS (Warnings only - won't fail CI)
echo -e "${YELLOW}🖥️ Running Informational Tests (UI Tests)${NC}"
xcodebuild test \
    -workspace "$WORKSPACE" \
    -scheme "$SCHEME" \
    -sdk iphonesimulator \
    -destination "$DESTINATION" \
    -only-testing:"${SCHEME}UITests" \
    CODE_SIGNING_ALLOWED='NO' \
    ENABLE_TESTABILITY=YES

INFORMATIONAL_TEST_RESULT=$?

# Report results
echo ""
echo "========================================="
echo -e "${YELLOW}📊 TEST RESULTS SUMMARY${NC}"
echo "========================================="

# Critical Tests (affect CI outcome)
if [ $CRITICAL_TEST_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ CRITICAL Tests (Unit): PASSED${NC}"
else
    echo -e "${RED}❌ CRITICAL Tests (Unit): FAILED${NC}"
fi

# Informational Tests (warnings only)
if [ $INFORMATIONAL_TEST_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ INFORMATIONAL Tests (UI): PASSED${NC}"
else
    echo -e "${YELLOW}⚠️ INFORMATIONAL Tests (UI): FAILED (warning only)${NC}"
fi

echo "========================================="

# Exit logic: Only CRITICAL tests can fail CI
echo ""
if [ $CRITICAL_TEST_RESULT -eq 0 ]; then
    if [ "$CI" = "true" ]; then
        echo -e "${GREEN}✅ CI Build: SUCCESS${NC}"
        echo -e "${YELLOW}ℹ️  Note: UI test failures are informational only${NC}"
    else
        echo -e "${GREEN}✅ Local Build: SUCCESS${NC}"
    fi
    exit 0
else
    if [ "$CI" = "true" ]; then
        echo -e "${RED}❌ CI Build: FAILED (critical tests failed)${NC}"
        echo -e "${YELLOW}ℹ️  UI test results are informational only${NC}"
    else
        echo -e "${RED}❌ Local Build: FAILED (critical tests failed)${NC}"
        echo -e "${YELLOW}ℹ️  Fix critical tests before pushing${NC}"
    fi
    exit $CRITICAL_TEST_RESULT
fi
