# Google and Facebook sign-in setup

The app sends provider IDs to `/appusers/saveuser/`; the backend response must
contain an app `token` or `access_token`. OAuth client IDs belong to this app
and have to be created in the provider dashboards. Do not use a Google client
secret or Facebook App Secret in Flutter.

## Google

1. In [Google Cloud Console](https://console.cloud.google.com/), create/select a
   project and configure the OAuth consent screen with the app name and support
   email. Add test users while the consent screen is in testing.
2. Create OAuth client IDs for Android and iOS. Android package name currently
   is `com.example.flutter_app`; register the SHA-1 for each signing key used
   (get debug SHA-1 with `cd android && ./gradlew signingReport`). iOS bundle ID
   currently is `com.samuelbenguluri.zion`.
3. Copy the **Web application** OAuth client ID into
   `SocialAuthConfig.googleServerClientId`. This is the server client ID sent
   during sign-in; Android also needs its Android OAuth client registered with
   the package name and SHA-1.
4. Copy the iOS OAuth client ID into `googleIosClientId`. Its reversed client ID
   (the client ID with its components reversed and the
   `com.googleusercontent.apps.` prefix) goes in `googleIosReversedClientId`
   and must be added as a URL scheme in `ios/Runner/Info.plist`.

## Facebook

1. In [Meta for Developers](https://developers.facebook.com/apps/), create an
   app and add the Facebook Login product for Android and iOS.
2. Copy the App ID and Client Token into `SocialAuthConfig.facebookAppId` and
   `facebookClientToken`. Never put the App Secret in the app.
3. In Meta's Android settings, use package name `com.example.flutter_app`, the
   launch activity `com.example.flutter_app.MainActivity`, and add the Android
   signing key hash. In iOS settings, use bundle ID
   `com.samuelbenguluri.zion` and configure the `fb{APP_ID}` URL scheme.
4. Replace the Facebook placeholders in `android/app/src/main/res/values/strings.xml`
   and `ios/Runner/Info.plist`. Replace both the `fb{APP_ID}` scheme and Google
   reversed client ID scheme in `Info.plist` with the real values. The Android
   manifest metadata and iOS Facebook keys/URL scheme are already scaffolded.

After entering credentials, run `flutter pub get` and launch on a real or
simulated device. To ship on Android, register both debug and release signing
keys with the providers. Facebook email may be absent for some accounts; this
integration identifies Facebook users by Facebook user ID.
