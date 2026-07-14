# الوسيط المدرسي والأنشطة (School & Activity Mediator)

A complete Flutter/Dart Android app: parents pick a child + subject, browse
a customized project/DIY idea bank, generate posters & certificates, and
either print at home (real PDF sent to the Android print dialog) or order
from a print-on-demand network (with live mocked delivery tracking).

## Architecture

```
lib/
  main.dart                    # App entry point, MaterialApp, RTL + Provider setup
  theme/app_theme.dart         # Colors, typography (Cairo), component themes
  models/                      # Plain data classes
    child_profile.dart
    project_idea.dart
    poster_template.dart
    diy_guide.dart
    order.dart
  data/mock_data.dart          # Seed content: 14 projects, 8 poster templates, 6 DIY guides
  state/app_state.dart         # ChangeNotifier "mock backend": profiles, filters,
                                # orders, premium flag, simulated delivery tracker
  services/pdf_service.dart    # Builds real PDFs (worksheets + posters) and sends
                                # them to Android's native print dialog
  widgets/                     # Reusable UI: buttons, cards, checklist, stepper...
  screens/
    root_shell.dart            # Bottom navigation (5 tabs)
    home_screen.dart           # Step 1: pick child / subject
    project_wizard_screen.dart # Step 2: filtered idea bank (بنك الأفكار)
    project_detail_screen.dart # Step 3: materials checklist + steps + print/order
    visual_matcher_screen.dart # Poster/badge/certificate template gallery
    poster_customize_screen.dart # Logo upload, live preview, size, generate+print
    diy_guide_screen.dart / diy_guide_detail_screen.dart # ركن الأشغال اليدوية
    checkout_screen.dart       # Two-path smart printing & shipping
    order_tracking_screen.dart # Live mocked delivery tracker
    orders_list_screen.dart / profiles_screen.dart
utils/arabic_helpers.dart      # Grade labels, Arabic date/time formatting
```

**State management:** a single `AppState` (Provider/ChangeNotifier) acts as
an in-memory mock database — every write (`addProfile`, `placeOrder`, etc.)
goes through a short artificial delay to emulate a real API/DB call, and
print-on-demand orders auto-progress through `pending → confirmed →
printing → shipped → delivered` in the background.

**Real (not mocked) functionality:** the "طباعة منزلية" (home printing) and
poster generator flows build actual PDF files with the `pdf` package and
hand them to Android's native print dialog via the `printing` package —
you can genuinely print or save them as PDF on a real device.

## Design system
Vibrant, family-friendly palette (violet primary, orange/teal/pink/yellow
accents), fully RTL, Cairo font via `google_fonts`, rounded 18–22px corners,
soft shadows, freemium banner + discreet "مساحة إعلانية" ad placeholders.

---

## How to compile this into an installable .apk

You have three good options. Pick whichever you're most comfortable with.

### Option A — Firebase Studio (formerly "Project IDX") — easiest, no install

1. Go to **https://studio.firebase.google.com** and sign in with a Google account.
2. Click **New workspace → Flutter** (this scaffolds a default Flutter project
   with the `android/`, `ios/`, `web/` folders already generated for you).
3. In the file tree, **delete** the generated `lib/main.dart` and the default
   `pubspec.yaml`, then upload/paste every file from this project's `lib/`
   folder (keeping the same sub-folder structure) and replace `pubspec.yaml`
   with the one provided here. Also copy `analysis_options.yaml`.
4. Open the built-in terminal and run:
   ```
   flutter pub get
   ```
5. To test instantly: click **Run** and pick the built-in Android emulator.
6. To get the actual APK, run in the terminal:
   ```
   flutter build apk --release
   ```
7. The file appears at `build/app/outputs/flutter-apk/app-release.apk`.
   Right-click it in the file tree → **Download**.

### Option B — FlutLab.io — easiest for a quick signed APK

1. Go to **https://flutlab.io** and create a free account.
2. **New Project → Flutter App**, name it `school_activity_mediator`.
3. In the FlutLab file explorer, delete the default `lib/main.dart`, then
   create the same folder structure shown above and paste in each file's
   content from this project (`main.dart`, `theme/`, `models/`, `data/`,
   `state/`, `services/`, `widgets/`, `screens/`, `utils/`).
4. Open `pubspec.yaml` in FlutLab and replace its contents with the
   `pubspec.yaml` provided here, then click **Get Packages** (this runs
   `flutter pub get` for you).
5. Click **Run** to preview on FlutLab's virtual device, or go straight to
   **Build → Android → APK**.
6. Once the build finishes, click **Download** to get the `.apk` file
   directly to your computer — install it on any Android phone (you may
   need to enable "install from unknown sources").

### Option C — Android Studio (local machine) — best for real device testing

1. Install **Flutter SDK** (flutter.dev/docs/get-started/install) and
   **Android Studio** with the Flutter/Dart plugins.
2. In a terminal:
   ```
   flutter create school_activity_mediator
   cd school_activity_mediator
   ```
3. Delete the generated `lib/main.dart` and `pubspec.yaml`. Copy in every
   file from this project's `lib/` folder and the provided `pubspec.yaml`
   and `analysis_options.yaml`, preserving the folder structure.
4. Set the Arabic app name shown under the icon: open
   `android/app/src/main/AndroidManifest.xml` and set
   `android:label="الوسيط المدرسي والأنشطة"` on the `<application>` tag.
5. Run:
   ```
   flutter pub get
   flutter build apk --release
   ```
6. Find the APK at `build/app/outputs/flutter-apk/app-release.apk`. Copy it
   to your phone and install it, or connect a device via USB and run
   `flutter install`.

### Option D — GitHub Actions (fully automated, recommended if you have a GitHub account)

This project already includes `.github/workflows/build-apk.yml`, which builds
a real release APK on GitHub's servers (which — unlike most sandboxes — have
full access to Google's Flutter/Android download servers) every time you push.

1. Create a new **public** repo on GitHub (public makes the download link
   login-free; private works too, you'll just need to be signed in to fetch it).
2. Push this entire folder to it:
   ```
   cd school_activity_mediator
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/<your-username>/<your-repo>.git
   git push -u origin main
   ```
3. Go to the **Actions** tab on GitHub — you'll see "Build Android APK"
   running automatically. It takes a few minutes.
4. Once it's green, open the **Releases** section on the right side of the
   repo's main page. Your `app-release.apk` will be attached to a release
   named "Build #1" — click it to download directly to your phone or PC.
   (It's also available under the workflow run's "Artifacts" section if you
   prefer that.)
5. Any time you push a change, a new build + release is created automatically.

### Troubleshooting tips
- If `flutter pub get` reports a version conflict, remove the `^x.y.z`
  version pins in `pubspec.yaml` and let it resolve automatically, or run
  `flutter pub upgrade --major-versions`.
- `google_fonts` fetches the Cairo font from Google's servers on first run,
  so the very first launch needs internet access (after that it's cached).
- `image_picker` needs gallery/camera permission on the device — Android
  will prompt automatically the first time "رفع شعار" is tapped.
- If the print dialog doesn't appear on an emulator, test on a real device
  or use **Share** instead — `Printing.layoutPdf` falls back to a share
  sheet if no printer/PDF-save option is detected.
