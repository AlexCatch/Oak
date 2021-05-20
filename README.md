# 🔒📱 OakOTP
![iOS Version](https://img.shields.io/badge/iOS-14.0+-orange)
![Swift](https://img.shields.io/badge/Swift-5-blue)
[![Build Status](https://alexcatch.semaphoreci.com/badges/Oak/branches/master.svg?style=shields)](https://alexcatch.semaphoreci.com/projects/Oak)
[![codecov](https://codecov.io/gh/AlexCatch/oak/branch/master/graph/badge.svg?token=JK2GGD5R9Z)](https://codecov.io/gh/AlexCatch/oak)
![License](https://img.shields.io/github/license/alexcatch/oak)

OakOTP is an iOS app built with SwiftUI for managing your 2FA codes.

[![Download](https://github.com/AlexCatch/Oak/blob/master/DesignAssets/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg)](https://apps.apple.com/gb/app/oakotp/id1567761178)

- Supports iPhone & iPad
- Supports scanning a QR code or entering credentials manually
- Supports both TOTP & HOTP codes
- Fully sync accounts with iCloud across all your devices
- Secured with biometrics or a password
- Built with SwiftUI utilising the MVVM pattern
- Dependency Injection for easy mocking in tests
- Decent Unit & UI test coverage

<br>

<div>
  <img style="float: right;" width=200 src="https://github.com/AlexCatch/Oak/blob/master/DesignAssets/setup.png">
  <img style="float: right;" width=200 src="https://github.com/AlexCatch/Oak/blob/master/DesignAssets/accounts.png">
  <img style="float: right;" width=200 src="https://github.com/AlexCatch/Oak/blob/master/DesignAssets/new.png">
  <img style="float: right;" width=200 src="https://github.com/AlexCatch/Oak/blob/master/DesignAssets/settings.png">
</div>

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

OakOTP uses [Fastlane](https://docs.fastlane.tools/getting-started/ios/setup/) for running tests so make sure you have Fastlane setup and configured on your machine.

### Installation

1. Clone the repo
   ```sh
   git clone git@github.com:AlexCatch/Oak.git
   ```
2. Run Bundler
   ```sh
   bundle install
   ```
3. Open `OakOTP.xcodeproj` and configure signing for each target (Automatically managing signing will suffice.)

### Running Tests

You can either run tests through Xcode or run `bundle exec fastlane test` from your terminal to run all unit and UI tests

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Make sure your changes are tested either with unit or UI tests. (`bundle exec fastlane test`)
4. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
5. Push to the Branch (`git push origin feature/AmazingFeature`)
6. Open a Pull Request

<!-- CONTACT -->
## Contact

If you need to reach out, shoot me an email at `alex@alexcatchpoledev.me` or you can find me on [LinkedIn](https://www.linkedin.com/in/alex-catch/)

### Built With

A few open-source packages are used in OakOTP - you can find them listed below.

* [CodeScanner](https://github.com/twostraws/CodeScanner)
* [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift)
* [KeychainSwift](https://github.com/evgenyneu/keychain-swift)
* [Resolver](https://github.com/hmlongco/Resolver)
* [SwiftlySearch](https://github.com/thislooksfun/SwiftlySearch)
* [SwiftOTP](https://github.com/lachlanbell/SwiftOTP)

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.
