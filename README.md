# This repository is archived as of 2023. The streams and accounts this project were using are no longer available, and when still available had introduced DRM.

## What is FootyCast

FootyCast allows you to use your streaming account (Paid or Free) to watch matches either on device or on external devices using AirPlay or Google Cast.

---

## Sideloading (Prebuilt - easiest)

1. Get a free Apple dev account (Normal Apple ID should be fine)
2. Get the latest IPA from the [releases page](https://github.com/evanrobertson/FootyCast/releases/latest)
3. Get [Cydia Impactor](http://www.cydiaimpactor.com)
4. Drag IPA into Cydia Impactor to install to a connected iOS device
5. If this a first install with your AppleId you will need to trust your developer account on the device (Settings > General > Profiles & Device Management > Developer App > 'YourAppleID' > Trust 'YourAppleID')
6. Open the app on your device
7. Add your paid login credentials on the settings tab OR copy your mis-uuid from the account page in the official app and paste in the settings of FootyCast

---

## From source (Self-Build)

1. Clone the repository
2. Run `pod install`
3. Open `FootyCast.xcworkspace`
4. Install to a device
5. Add your paid login credentials on the settings tab OR copy your mis-uuid from the account page in the official app and paste in the settings of FootyCast

---

## Troubleshooting

#### Impactor -> Please sign in with an app specific password
You most likey have two factor authentication on for your apple id, you can either turn off 2FA while installing or generate an app specific password to use with Impactor at https://appleid.apple.com/
