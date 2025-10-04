# Thrive Church Official App

A modern iOS application for Thrive Community Church in Estero, FL, designed to help members and visitors stay connected with sermons, take notes, and engage with the church community.

## 📱 Download

[![Download on the App Store](https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg)](https://itunes.apple.com/us/app/thrive-church-official-app/id1138008288?mt=8)

Search for **"Thrive Church Official App"** in the Apple App Store.

## 🎯 Key Features

- **🎧 Listen**: Stream sermons, download for offline listening, and access your recently played content
- **📝 Notes**: Take and organize sermon notes with full text editing capabilities
- **🤝 Connect**: Get church information, contact details, and stay updated with announcements
- **📖 Bible**: Access scripture through YouVersion integration with traditional and alphabetical book sorting
- **➕ More**: Secure giving, social media links, team information, and app settings

## 🛠 Technical Specifications

- **iOS Version**: iOS 15.0 or later
- **Devices**: iPhone and iPad (Universal app)
- **Language**: Swift 5 with UIKit and programmatic AutoLayout
- **Architecture**: MVC with Coordinator pattern for navigation
- **Dependencies**: CocoaPods for dependency management
- **Analytics**: Firebase Analytics and Crashlytics
- **Design**: Modern card-based UI with dark theme and responsive layouts

## 🚀 Quick Start

### Prerequisites
- Xcode 15.0 or later
- iOS 15.0+ deployment target
- CocoaPods installed (`sudo gem install cocoapods`)

### Setup Instructions

1. **Clone and setup**:
   ```bash
   git clone https://github.com/ThriveCommunityChurch/ThriveChurchOfficialApp.git
   cd ThriveChurchOfficialApp
   pod install
   ```

2. **Open workspace**:
   ```bash
   open "Thrive Church Official App.xcworkspace"
   ```

3. **Configure required files**:
   - Add your `GoogleService-Info.plist` file to the project
   - Create or update `Config.plist` with your API endpoints and ESV API key

4. **Build and run** (⌘+R)

### ⚙️ Configuration Files

#### Config.plist Setup
Create a `Config.plist` file in your project root with the following structure:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>APIUrl</key>
    <string>your-api-domain.com</string>
    <key>ESVApiKey</key>
    <string>your-esv-api-key-here</string>
</dict>
</plist>
```

#### ESV API Configuration
The app integrates with the ESV (English Standard Version) Bible API for scripture reading functionality:

1. **Get your ESV API key**:
   - Visit [https://api.esv.org/](https://api.esv.org/)
   - Create a free account
   - Generate an API key for your application

2. **API Usage**: The ESV API provides:
   - Bible passage text retrieval
   - Audio playback of scripture
   - Integration with sermon content

**Note**: The ESV API is free for non-commercial use with reasonable rate limits. See their [terms of service](https://api.esv.org/docs/) for details.

## 🧪 Testing

This project includes comprehensive unit and UI test suites. For detailed testing information:

- **Unit Tests**: See [`Thrive Community ChurchTests/README.md`](Thrive%20Community%20ChurchTests/README.md)
- **UI Tests**: See [`Thrive Community ChurchUITests/TESTING.md`](Thrive%20Community%20ChurchUITests/TESTING.md)
- **Root Testing Scripts**: See [`testing.md`](testing.md)
- **CI/CD Testing**: See [`ci_testing.md`](ci_testing.md)

**Quick test commands**:
```bash
./run-tests.sh unit    # Unit tests only
./run-tests.sh ui      # UI tests only
./run-tests.sh all     # All tests
```

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

## 🤝 Contributing

Read our [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

**Before submitting PRs**: Ensure all tests pass by running `./run-tests.sh all`

## 📚 Documentation

- **[Version History](VersionHistory.md)** - Release notes and changelog
- **[Contributing Guidelines](CONTRIBUTING.md)** - How to contribute to the project
- **[Testing Documentation](testing.md)** - Root-level testing scripts and utilities
- **[CI/CD Documentation](ci_testing.md)** - Continuous integration and automated testing

---

**Version**: 1.7.9 | **Build**: 313 | **iOS**: 15.0+ | **Last Updated**: 2024

### Acknowledgements
Thank you to everyone who uses this application, we made it for you - to help make taking notes and hearing the gospel message that much easier for you. Made with ❤
