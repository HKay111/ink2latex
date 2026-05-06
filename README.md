# Ink2LaTeX ✍️➡️📄

**Convert handwriting to LaTeX in real-time. Write like you're using pen and paper, get clean LaTeX code you can paste straight into your `.tex` files.**

Built for students who take mixed notes — text, equations, and diagrams — and want their math to look professional without typing a single `\frac`.

## Download

[![Latest Release](https://img.shields.io/github/v/release/HKay111/ink2latex?label=Download%20APK)](https://github.com/HKay111/ink2latex/releases/latest)

**Android tablet/phone:** Grab the APK from [Releases](https://github.com/HKay111/ink2latex/releases/latest). Install and go.

**Auto-update with [Obtanium](https://github.com/ImranR98/Obtainium):** Add `https://github.com/HKay111/ink2latex` — it'll watch for new releases and update automatically.

## How It Works

```
You write on screen
        │
        ▼
   ┌─────────────┐
   │  T1: ML Kit │  ~10ms   Free, offline, handles regular text
   │  (Google)   │
   └──────┬──────┘
          │ low confidence?
          ▼
   ┌─────────────┐
   │  T2: Gemma  │  ~300ms  Free, offline, math + handwriting
   │  (on-device)│  (coming soon — Google's SDK in preview)
   └──────┬──────┘
          │ still unclear?
          ▼
   ┌─────────────┐
   │  T3: Mathpix│  ~2s     $19.99 one-time, best accuracy
   │  (cloud)    │  optional — only activates if configured
   └──────┬──────┘
          │
          ▼
   ┌──────────────┐
   │ KaTeX preview │  See rendered math instantly
   │  + copy LaTeX │  Tap to copy → paste into .tex file
   └──────────────┘
```

Three tiers cascade automatically. Fast text stays at T1. Complex math escalates to T2 (or T3). You don't think about it — you just write.

## Features

- **Real-time handwriting → LaTeX** — write an equation, see it rendered
- **3-tier recognition** — gets smarter the harder the math gets
- **Copy to clipboard** — one tap, paste into Overleaf/VS Code/any `.tex` file
- **Live KaTeX preview** — see your math rendered before you export
- **Folder organization** — courses → topics → notes
- **Works offline** — T1 runs without internet. T2 (coming) runs without internet.
- **Phone + tablet** — responsive layout adapts automatically
- **Dark theme** — easy on the eyes during late-night study sessions

## Setup (Developers)

### Prerequisites

```bash
# Flutter SDK 3.41+
flutter --version

# Android SDK for APK builds
# iOS: Xcode 15.3+ for iPad builds
```

### Build from source

```bash
git clone https://github.com/HKay111/ink2latex.git
cd ink2latex
flutter pub get
flutter run          # debug mode on connected device
flutter build apk --release   # signed APK for distribution
```

### Enable Mathpix (T3) — optional

1. Sign up at [mathpix.com/pricing/api](https://mathpix.com/pricing/api) ($19.99 one-time setup)
2. Create an organization, copy your API key (format: `app_id:app_key`)
3. Open `lib/config.dart` and replace:
   ```dart
   static const String mathpixApiKey = '';
   ```
   with:
   ```dart
   static const String mathpixApiKey = 'your_app_id:your_app_key';
   ```
4. Rebuild — T3 activates automatically for complex math

### Run tests

```bash
flutter test          # 32 tests
flutter analyze       # zero issues
```

## Architecture

```
lib/
├── models/          Folder, Note, Page, LaTeXBlock — immutable data
├── services/        T1/T2/T3 recognizers, pipeline, storage, export
├── widgets/         Canvas, toolbar, preview pane, folder tree, nav
└── utils/           Ink serializer, responsive layout
```

Built with Flutter, Provider for state, KaTeX for math rendering, ML Kit for handwriting recognition. Platform bridges ready for Gemma integration on Android (AICore) and iOS (CoreML).

## What's Next

- [ ] **T2: Gemma E2B/E4B** — Google's on-device AI for math OCR (waiting on stable SDK)
- [ ] **PDF export** — render full pages to PDF with embedded LaTeX
- [ ] **Cloud sync** — backup notes across devices
- [ ] **Audio recording** — record lectures while taking notes
- [ ] **Handwriting search** — search your handwritten notes

## License

Apache 2.0 — free for personal use, research, and startups under $2M revenue.
