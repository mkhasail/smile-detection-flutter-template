# 😐 Smile Detection Template

**A production-ready Flutter starter kit for building smile detection games and apps.**

Includes ML Kit face detection, Supabase backend integration, and example UI. Everything you need to launch your detection game in 48 hours.

---

## What's Included

✅ **ML Kit Smile Detection** — Real-time smile detection via front camera  
✅ **Supabase Backend** — Slide content, game results, user data  
✅ **Camera Integration** — Optimized for Android & iOS  
✅ **Game Screen Example** — Ready-to-customize UI  
✅ **Full Documentation** — Step-by-step setup guide  
✅ **Working Game Loop** — Detect smiles, trigger game over, log results  

---

## What You Can Build

- Smile detection games (like "No Smiling")
- Face detection apps that reward keeping a straight face
- Emotion-detection mini-games
- Interactive filters that detect smiles
- Challenge games with leaderboards
- Content apps that pause/trigger on smile detection

---

## Quick Start

### 1. Prerequisites
- Flutter 3.0+ installed
- Android SDK (or iOS SDK) configured
- Free Supabase account: https://supabase.com

### 2. Clone & Setup
```bash
git clone <this-repo>
cd smile_detection_template
flutter pub get
```

### 3. Add Your Supabase Keys
Open `lib/main.dart` and replace:
```dart
await SupabaseService.initialize(
  supabaseUrl: 'YOUR_SUPABASE_URL',  // ← Paste your URL
  supabaseKey: 'YOUR_SUPABASE_KEY',   // ← Paste your public key
);
```

Get these from your Supabase dashboard: **Settings → API**

### 4. Run on Emulator
```bash
flutter run
```

Or on a real device:
```bash
flutter run
```

---

## File Structure

```
lib/
├── main.dart                    # App entry, Supabase init
├── screens/
│   └── game_screen.dart        # Example game UI
└── services/
    ├── smile_detection_service.dart   # ML Kit logic
    └── supabase_service.dart          # Backend integration
```

---

## How It Works

### Smile Detection Flow
1. **Camera feed** starts when game begins
2. **ML Kit processes frames** looking for faces
3. **Detects smile probability** (0.0-1.0 scale)
4. **Triggers game over** when smile > 0.7 threshold
5. **Logs result** to Supabase database

### Supabase Integration
- Fetch slides/content from database
- Store game results (slides seen, duration, smile detected)
- Support multiple "slide packs" (free vs. paid)
- User data persistence

---

## Customization Guide

### Change Smile Threshold
In `smile_detection_service.dart`:
```dart
isSmiling = faces.any((face) => face.smilingProbability! > 0.7);
//                                                          ↑
//                                              Change this value
```
- `0.5` = Very sensitive (detects slight grins)
- `0.7` = Balanced (recommended)
- `0.9` = Very strict (only full smiles)

### Use Back Camera Instead
In `initializeCamera()`:
```dart
final frontCamera = cameras.firstWhere(
  (camera) => camera.lensDirection == CameraLensDirection.back,  // ← Change this
```

### Add Custom UI
Replace `game_screen.dart` with your own design. Keep the `SmileDetectionService` logic intact.

### Add Analytics
Use `SupabaseService.logGameResult()` to track:
- How many slides players see
- How often smile detection triggers
- Game duration

---

## Database Setup (Supabase)

Create these tables in your Supabase project:

### `slides` table
```sql
CREATE TABLE slides (
  id INT PRIMARY KEY,
  content_url TEXT NOT NULL,
  content_type TEXT,
  pack_id TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### `game_results` table
```sql
CREATE TABLE game_results (
  id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  slides_seen INT,
  smile_detected BOOLEAN,
  duration_seconds INT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## Permissions (Android)

Ensure your `AndroidManifest.xml` includes:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
```

Flutter should auto-configure these, but double-check in `android/app/src/main/AndroidManifest.xml`.

---

## Performance Tips

- **Reduce frame processing** — Increase `Future.delayed(Duration(milliseconds: 100))` in `_startGameLoop()` to process fewer frames (saves battery)
- **Lower camera resolution** — Change `ResolutionPreset.high` to `ResolutionPreset.medium` for weaker devices
- **Optimize ML Kit** — Disable unnecessary face features (age, gender) in `FaceDetectorOptions`

---

## Known Limitations

- Front camera required (back camera detection works, but less reliable)
- Requires permission grant on first run
- ML Kit works on Android 5.0+, iOS 11+
- Network needed for Supabase (offline mode requires extra setup)

---

## Troubleshooting

**"Camera permission denied"**
- Grant camera permission on device settings

**"ML Kit errors"**
- Ensure `google_mlkit_face_detection` is installed: `flutter pub get`
- Check Google Play Services on device (Settings → Apps → Google Play Services)

**"Supabase connection failed"**
- Verify your URL and key are correct
- Check internet connection
- Ensure Supabase project is active

---

## Support & Questions

- Review the inline code comments
- Check Supabase docs: https://supabase.com/docs
- ML Kit docs: https://developers.google.com/ml-kit/vision/face-detection

---

## License

Free to use, modify, and distribute. Attribution appreciated.

---

**Built with Flutter, ML Kit, and Supabase.**

Made for creators who want to launch fast.
