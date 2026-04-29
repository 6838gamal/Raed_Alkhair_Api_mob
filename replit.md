# Raed AlKhair — Flutter Web App

## Overview
A Flutter app (originally created with FlutLab) for "شركة رائد الخير", an Iraqi distributor for DXN International. The app supports three languages: Arabic, English, and Kurdish. Includes login/signup, product categories, cart, checkout, and order screens.

## Project Structure
- `lib/` — Dart source code (screens, tabs, main entry)
- `web/` — Flutter web bootstrap files
- `android/`, `ios/` — Native mobile project shells (not used in Replit)
- `assets/images/` — Image assets (placeholders used here; replace with real artwork)
- `pubspec.yaml` — Dart dependencies and asset declarations
- `build/web/` — Production web build (generated, served by the workflow)

## Tech Stack
- Flutter 3.32 / Dart 3.8 (installed via Nix system dependency)
- flutter_riverpod (state management)
- flutter_localizations + intl (i18n)
- go_router (routing)
- dio (HTTP)
- shared_preferences (local storage)

## Replit Setup
- Flutter is installed as a Nix system package.
- Image asset folder `assets/images/` is required by code; placeholder JPGs are bundled so the app renders.
- The web app is built once with `flutter build web --release` and served as static files.
- Workflow `Start application` runs `dhttpd --host 0.0.0.0 --port 5000 --path build/web` (Dart static file server, installed via `dart pub global activate dhttpd`).
- Port 5000 is used for the webview preview.

## Development Notes
- Debug mode (`flutter run -d web-server`) does not work well behind the Replit iframe proxy because the DDC require.js loader fails to fetch dev modules. The release build sidesteps this entirely.
- After making code changes, rebuild with `flutter build web --release` and restart the workflow.
- Real product/background images can be dropped into `assets/images/` (using the existing filenames) to replace the placeholders.

## Deployment
Configured for Replit Autoscale deployment serving the static `build/web` directory on port 5000.
