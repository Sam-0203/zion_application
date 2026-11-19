# Zion — Word of God

Zion is a Flutter application for exploring Bible content and songs, with language preferences, user accounts, and community chat features backed by the companion Zion API.

## App capabilities

- Bible reading, scripture search, and verse of the day
- Songs and lyrics
- Language preferences
- Account sign-in and profile flows
- Messaging and call-related features where the backend is configured
- Audio playback and sharing support

## Tech stack

- Flutter and Dart
- GetX for routing and dependency management
- HTTP services
- Secure local session storage
- Audio playback with `audioplayers` and `audio_service`

## Getting started

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Configure the API/server settings and any authentication providers for your environment.
3. Clone this repository and run:

   ```bash
   flutter pub get
   flutter run
   ```

## Development checks

```bash
flutter analyze
flutter test
```

## Related backend

The companion API project is [`zion_backed_code`](https://github.com/Sam-0203/zion_backed_code). Ensure its endpoints and the app's configured API base URL match before testing integrated flows.

## License

No license is currently specified. Contact the repository owner before reuse or redistribution.
