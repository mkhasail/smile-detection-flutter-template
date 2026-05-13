# Android Setup Guide

## Step 1: Verify Flutter & Android SDK
```bash
flutter doctor
```

Make sure you see:
- ✓ Flutter (version 3.0+)
- ✓ Android SDK
- ✓ Android SDK Platform 31+

---

## Step 2: ML Kit Dependency (Already in pubspec.yaml)

The package `google_mlkit_face_detection` is already configured.

Run:
```bash
flutter pub get
```

---

## Step 3: AndroidManifest.xml Permissions

Flutter usually handles this automatically, but verify `android/app/src/main/AndroidManifest.xml` includes:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
```

These should already be there. If not, add them under `<manifest>`.

---

## Step 4: Test on Emulator

```bash
flutter emulators
```

List available emulators.

```bash
flutter emulators --launch Pixel_4_API_30
```

Wait for emulator to boot, then:

```bash
flutter run
```

---

## Step 5: Test on Real Device

1. **Connect Android phone via USB**
2. **Enable USB Debugging** on phone:
   - Settings → About Phone → Tap "Build Number" 7 times
   - Settings → Developer Options → Enable USB Debugging
3. **Grant USB permissions** on phone (popup)
4. Run:
```bash
flutter devices
```

You should see your device listed.

```bash
flutter run
```

---

## Troubleshooting

### "No Android SDK found"
```bash
flutter config --android-sdk /path/to/android/sdk
```

Replace `/path/to/android/sdk` with your actual SDK path (e.g., `C:\Android\sdk` on Windows).

### "Camera permission denied"
- You must grant camera permission on first run
- Go to device Settings → Apps → [Your App Name] → Permissions → Camera → Allow

### "ML Kit errors at runtime"
- Ensure Google Play Services is updated on device
- Device must have Android 5.0+

### Build fails with "Build failed"
```bash
flutter clean
flutter pub get
flutter run
```

---

## Release Build (For Play Store)

When ready to ship:

```bash
flutter build appbundle
```

This creates a file at `build/app/outputs/bundle/release/app-release.aab`

You'll need to sign it. See: **SIGNING_GUIDE.md** (included in template)

---

## That's It!

Your app is now ready to test smile detection on Android.
