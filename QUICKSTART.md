# Quick Start (5 Minutes)

## 1. Install Flutter
If you haven't: https://flutter.dev/docs/get-started/install

## 2. Get Dependencies
```bash
flutter pub get
```

## 3. Add Your Supabase Keys
Open `lib/main.dart` and find:
```dart
await SupabaseService.initialize(
  supabaseUrl: 'YOUR_SUPABASE_URL',
  supabaseKey: 'YOUR_SUPABASE_KEY',
);
```

Replace those strings with your actual Supabase credentials from: **https://app.supabase.com → Settings → API**

## 4. Run
```bash
flutter run
```

That's it. The app will open. Tap "Start Game" to test smile detection.

---

## Next Steps

- See `README.md` for detailed customization
- See `ANDROID_SETUP.md` for Android-specific help
- Modify `lib/screens/game_screen.dart` to change UI
- Change smile threshold in `lib/services/smile_detection_service.dart`

---

Enjoy building! 😐
