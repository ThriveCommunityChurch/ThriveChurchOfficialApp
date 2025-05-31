# Thrive Church Official App

A modern iOS application for Thrive Community Church in Estero, FL, designed to help members and visitors stay connected with sermons, take notes, and engage with the church community.

## 📱 Download

[![Download on the App Store](https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg)](https://itunes.apple.com/us/app/thrive-church-official-app/id1138008288?mt=8)

Search for **"Thrive Church Official App"** in the Apple App Store.

## 🎯 Features

### 🎧 Listen Section
- **Sermon Series Browsing**: Browse current and past sermon series with beautiful card-based layouts
- **Audio Playback**: Stream sermons with integrated audio player controls
- **Offline Downloads**: Download sermons for offline listening
- **Recently Played**: Quick access to your listening history
- **Now Playing**: Always-accessible playback controls
- **HD Video Streaming**: Watch sermons in high definition via YouTube integration
- **Live Streaming**: Access live church services through Facebook integration

### 📝 Notes Functionality
- **Sermon Notes**: Take notes during sermons with full text editing capabilities
- **Note Management**: Create, edit, and organize your notes
- **Local Storage**: Notes are saved securely on your device
- **Sharing**: Share notes with friends or save for later reference
- **Modern UI**: Card-based design with enhanced typography and spacing

### 🤝 Connect Tab
- **Church Information**: Get directions to the church location
- **Contact Options**: Email, call, or submit prayer requests
- **Announcements**: Stay updated with latest church news
- **Small Groups**: Find ways to connect with community
- **Volunteer Opportunities**: Discover ways to serve

### 📖 Bible Integration
- **YouVersion Integration**: Access Bible passages through YouVersion app
- **Traditional & Alphabetical Sorting**: Browse books of the Bible in your preferred order
- **Quick Access**: Seamlessly integrated scripture reading

### ➕ More Tab
- **Secure Giving**: Support the church mission through secure online giving
- **Social Media**: Connect with Thrive Church on social platforms
- **Team Information**: Meet the staff and leadership
- **App Settings**: Manage notifications and preferences
- **Support Tools**: Send diagnostic logs for technical support

## 🛠 Technical Specifications

### System Requirements
- **iOS Version**: iOS 15.0 or later
- **Devices**: iPhone and iPad (Universal app)
- **Storage**: Varies with downloaded content
- **Network**: Internet connection required for streaming (offline playback available for downloaded content)

### Supported Devices
- **iPhone**: iPhone SE (3rd generation) and newer
- **iPad**: All iPad models supporting iOS 15.0+
- **Adaptive Layouts**: Responsive design optimized for all screen sizes

### Key Technologies
- **Language**: Swift 5
- **UI Framework**: UIKit with programmatic AutoLayout
- **Audio**: AVFoundation for media playback
- **Networking**: URLSession for API communication
- **Analytics**: Firebase Analytics and Crashlytics
- **Push Notifications**: Firebase Cloud Messaging
- **Dependencies**: CocoaPods for dependency management

## 🏗 Architecture & Design

### Modern iOS Design Patterns
- **100% Programmatic UI**: Complete migration from storyboards to programmatic AutoLayout
- **Card-Based Design**: Modern UI with 12pt rounded corners and subtle shadows
- **Dark Theme**: Consistent dark aesthetic throughout the app
- **Responsive Layouts**: Adaptive design for iPhone and iPad with maximum content width constraints
- **Enhanced Typography**: Hierarchical text styling with improved readability

### App Architecture
- **Coordinator Pattern**: Centralized navigation management through AppCoordinator
- **Tab-Based Navigation**: Four main sections (Listen, Notes, Connect, More)
- **MVC Architecture**: Clean separation of concerns with model-view-controller pattern
- **Offline Capability**: Local storage for downloaded content and notes
- **Network Resilience**: Graceful handling of connectivity changes

### Design Specifications
- **Margins**: 16pt horizontal margins, 8pt vertical spacing
- **Shadows**: 4pt offset, 8pt radius, 0.4 opacity
- **Animations**: Smooth spring animations (0.75 damping, 0.5 velocity)
- **Haptic Feedback**: Light feedback for toggles, medium for buttons
- **Accessibility**: Full VoiceOver support and dynamic type compatibility

## 🚀 Installation & Setup

### Prerequisites
- Xcode 15.0 or later
- iOS 15.0+ deployment target
- CocoaPods for dependency management

### Build Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-repo/ThriveChurchOfficialApp.git
   cd ThriveChurchOfficialApp
   ```

2. **Install dependencies**:
   ```bash
   pod install
   ```

3. **Open workspace**:
   ```bash
   open "Thrive Church Official App.xcworkspace"
   ```

4. **Configure Firebase**:
   - Add your `GoogleService-Info.plist` file to the project
   - Ensure Firebase is properly configured for your environment

5. **Build and run**:
   - Select your target device or simulator
   - Build and run the project (⌘+R)

### Configuration
- **API Configuration**: Update `Config.plist` with appropriate API endpoints
- **Firebase Setup**: Configure Firebase project for analytics and push notifications
- **App Store Connect**: Configure for distribution if needed

## 📊 Testing

### Comprehensive Test Suite
- **UI Tests**: Complete XCUITest framework coverage
- **Device Testing**: iPhone SE to Pro Max, iPad 9th gen to Pro 12.9"
- **Orientation Testing**: Portrait and landscape validation
- **Layout Validation**: AutoLayout constraints and responsive design
- **Performance Testing**: Scrolling, navigation, and memory usage

### Running Tests
```bash
# Run all tests
xcodebuild test -workspace "Thrive Church Official App.xcworkspace" -scheme "Thrive Church Official App" -destination 'platform=iOS Simulator,name=iPhone 15 Pro Max'

# Run specific test class
xcodebuild test -workspace "Thrive Church Official App.xcworkspace" -scheme "Thrive Church Official App" -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch) (6th generation)' -only-testing:Thrive_Community_ChurchUITests/ListenTabUITests
```

## 🔄 Recent Improvements

### Storyboard Migration
- **Complete Elimination**: 100% migration from storyboards to programmatic AutoLayout
- **Performance**: Improved app launch time and memory usage
- **Maintainability**: Enhanced code maintainability and version control

### Modern Design Implementation
- **Card-Based UI**: Consistent card design across all tabs
- **Enhanced Typography**: Improved text hierarchy and readability
- **Responsive Design**: Better iPad support with adaptive layouts
- **Accessibility**: Improved VoiceOver support and dynamic type

### Technical Modernization
- **iOS 15+ Target**: Updated minimum deployment target for modern iOS features
- **Dependency Updates**: Latest Firebase SDK and third-party libraries
- **Code Quality**: Comprehensive UI test suite and improved error handling

## 👥 Team

### Development Team
- **[Wyatt Baggett](https://github.com/ksigWyatt)** - Lead Designer and Developer

### Quality Assurance
- **Phil Klopke** - Testing
- **[Joel Butcher](https://github.com/joelbutcher)** - QA

## 📞 Support

### Bug Reports & Feature Requests
- **Support Portal**: [http://thrive-fl.org/app-support/](http://thrive-fl.org/app-support/)
- **GitHub Issues**: Submit issues directly to this repository
- **Email Support**: Technical issues can be reported through the app's diagnostic tools

### Community
- **Church Website**: [https://thrive-fl.org](https://thrive-fl.org)
- **Social Media**: Follow @ThriveFl on social platforms
- **Location**: Thrive Community Church, Estero, FL

---

**Version**: 1.7.9 | **Build**: 313 | **iOS**: 15.0+ | **Last Updated**: 2024

### Acknowledgements
Thank you to everyone who uses this application, we made it for you - to help make taking notes and hearing the gospel message that much easier for you. Made with ❤

## 🧪 Testing

This project includes comprehensive unit and UI tests with resolved build configuration issues.

### Quick Test Commands

**Using convenience script** (recommended):
```bash
./run-tests.sh unit    # Unit tests only (~3s)
./run-tests.sh ui      # UI tests only (~30-60s)
./run-tests.sh all     # All tests
./run-tests.sh clean   # Clean environment
./run-tests.sh help    # Get help
```

**Using Xcode**:
- `Cmd+U` - Run all tests
- `Cmd+6` - Open Test Navigator

### Test Status
- ✅ **Unit Tests**: 2/2 passing
- ✅ **UI Tests**: Build issues resolved, 1/2 passing
- ✅ **Build Configuration**: Swift module conflicts fixed
- ✅ **Framework Dependencies**: All CocoaPods frameworks load correctly

For comprehensive testing documentation, see **[TESTING.md](TESTING.md)**.

## Contributing
Read our [CONTRIBUTING.md](https://github.com/ThriveCommunityChurch/ThriveChurchOfficialApp/blob/master/CONTRIBUTING.md) for more information.

**Before submitting PRs**: Ensure all tests pass by running `./run-tests.sh all`

## Version History
See all releases in the [VersionHistory.md](https://github.com/ThriveCommunityChurch/ThriveChurchOfficialApp/blob/master/VersionHistory.md)
