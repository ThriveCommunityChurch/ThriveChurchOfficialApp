## Contribution Guidelines

- Additions must be made via Pull Request
- Comments must be part of any additions made
- Comments must not be redundant                                         
_Explaining something easily seen in the code_
- Please be as descriptive as possible when creating new issues


## Getting Started
In order to test how the application will run against the Thrive Church Official API, ensure that your `Config.plist` contains a value for the key `APIUrl` this value will be the domain and port number (i.e. `localhost:12345`) for the API. That way the application can send a request to the correct API.

## How To Contribute
  1. Fork the repository.
  2. Install Xcode from the Mac App Store.                            
_macOS Requited to run Xcode_
  3. Clone the project to your machine.
  4. Send an email to wyatt@thrive-fl.org to be sent the project assets and marketing images.
  5. Make your changes.
  6. Make sure that your changes follow the Google Code Style Guide, found [here](https://developers.google.com/style/).             
_This makes code easier to read_
  7. Create a Pull Request to the Branch `dev` and wait for your request to be approved.
  
  ## Required Frameworks 
  _These are required to get the application to compile. Perform these before running the application in Xcode._              
  _Some of these are already included in the project repository, but if for some reason there is an issue here is the frameworks._
  
  1. CocoaPods  -  `sudo gem install cocoapods`
  
  2. Firebase Analytics - Follow the instructions on the [Firebase Site](https://firebase.google.com/docs/analytics/ios/start?gclid=CjwKCAjwo4jOBRBmEiwABWNaMTt6pAYCDfnQB2NZR2BaF8e3nqVV4ZOjarKqcyfcyzbzHC31GTS_QBoCUcEQAvD_BwE)
