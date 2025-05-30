#!/bin/bash

# Configuration
SCHEME='Thrive Church Official App'
WORKSPACE='Thrive Church Official App.xcworkspace'

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔨 Starting iOS Build for ${SCHEME}${NC}"
echo "Workspace: ${WORKSPACE}"
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

# CI-specific fixes for build consistency
if [ "$CI" = "true" ]; then
    echo -e "${YELLOW}🔧 Applying CI-specific fixes${NC}"

    # Clean any existing build artifacts for consistent builds
    rm -rf ~/Library/Developer/Xcode/DerivedData

    # Ensure pods are up to date
    echo -e "${YELLOW}🔧 Updating Pods for CI${NC}"
    pod install --repo-update
fi

echo -e "${GREEN}🔨 Building iOS App${NC}"
xcodebuild build \
    -workspace "$WORKSPACE" \
    -scheme "$SCHEME" \
    -sdk iphonesimulator \
    -configuration Debug \
    CODE_SIGNING_ALLOWED='NO'

BUILD_RESULT=$?

# Report results
echo ""
echo "========================================="
if [ $BUILD_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ Build: PASSED${NC}"
else
    echo -e "${RED}❌ Build: FAILED${NC}"
fi
echo "========================================="

exit $BUILD_RESULT
