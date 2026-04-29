# Raed AlKhair — Flutter Web App

## Overview
Flutter web app for "شركة رائد الخير" (Iraqi DXN distributor). Supports Arabic, English, Kurdish. All screens are connected to the live backend at `https://raed-alkhair-api.onrender.com`.

## Architecture
The backend is a FastAPI server-rendered app that uses HTTP cookie sessions and form-encoded POSTs (no CORS, no token-based auth). To use it from Flutter web safely:

1. A Dart shelf proxy (`tool/server.dart`) serves the compiled `build/web` and proxies all API/auth/cart routes to the upstream — same-origin so cookies "just work" without `withCredentials`, and there's no CORS issue.
2. Login/register/checkout responses are 303 redirects: success vs failure is detected by inspecting the `Location` header (e.g. `/branches` = success, `/login` = failed login).
3. The cart is persisted server-side inside the encrypted session cookie itself; a local mirror is kept in `CartService` so totals can be displayed.

## Project Structure
- `tool/server.dart` — proxy + static server (entry point of the workflow)
- `lib/models/` — `Branch`, `Category`, `Product`, `CartItem`, `AppUser`
- `lib/services/` — `ApiClient` (Dio), `AuthService`, `CatalogService`, `CartService`
- `lib/state/providers.dart` — Riverpod providers (`branchesProvider`, `categoriesProvider`, `productsProvider`, `cartTickProvider`, etc.)
- `lib/state/locale_provider.dart` — Riverpod `StateNotifier<Locale>` persisted in SharedPreferences (ar/en/ku)
- `lib/l10n/strings.dart` — Centralised translation map + `t(ref, key)` helper used by every screen
- `lib/*.dart` — screens (`login_screen`, `signup_screen`, `home_screen`, `categories_screen`, `sub_category_screen`, `order_screen`, `cart_screen`, `checkout_screen`, `success_screen`)
- `lib/tabs/` — `branches_tab`, `main_tab`, `profile_tab`
- `web/`, `pubspec.yaml`, `assets/images/` — standard Flutter web assets

## Localisation (AR / EN / KU)
- Language is global state via `localeProvider` (Riverpod). Selection is saved in SharedPreferences so it survives reloads.
- All UI text comes from `lib/l10n/strings.dart`; call `t(ref, 'key')` from any `ConsumerWidget`/`ConsumerState` to read the current language's value.
- `MaterialApp.builder` wraps the whole tree in a `Directionality` widget so `ar`/`ku` flip to RTL automatically and `en` switches to LTR.
- `localeResolutionCallback` falls back to Arabic for `ku` so Material's built-in widgets (date pickers, etc.) still render — our own copy comes from the strings table.
- Switchers exist on the login screen (bottom row), the home screen (top-left popup menu) and inside the profile tab (chip selector). Changing the language from any of them updates every screen instantly.

## Tech Stack
- Flutter 3.32 / Dart 3.8 (Nix-installed)
- Riverpod (state), Dio (HTTP), go_router (routing)
- shelf, shelf_static, shelf_proxy, http (proxy server)
- shared_preferences, intl, flutter_localizations

## Replit Setup
- Flutter and Dart are installed via Nix.
- The workflow `Start application` runs `dart run tool/server.dart` on port 5000. It serves the static `build/web` and proxies `/api/`, `/login`, `/register`, `/logout`, `/cart`, `/checkout`, `/profile`, `/products/`, `/branches`, `/orders/`, `/static/` to the upstream — preserving cookies and rewriting redirect locations.
- Rebuild with `flutter build web --release` then restart the workflow whenever Dart code changes.

## Development Notes
- Debug mode (`flutter run -d web-server`) does not work behind the Replit iframe proxy. Always use the release build.
- The browser auto-follows 303 redirects; for `/checkout` we read the order ID from `response.realUri.path` (e.g. `/orders/3/success`).
- Real product/background images can replace the placeholders in `assets/images/`.

## Deployment
Configured for Replit Autoscale, serving on port 5000 via the shelf proxy.
