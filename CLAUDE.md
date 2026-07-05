# tatetsu

Bill-splitting Flutter app (iOS / Android / Web).

## Tech stack

- Flutter stable (Dart SDK >=3.10.1 <4.0.0)
- Firebase (Analytics, Crashlytics, Core, App Distribution, Hosting)
- go_router, google_mobile_ads, flutter_flavor
- json_annotation + json_serializable (build_runner)
- flutter_localizations + intl (ARB-based i18n)
- lint

## Source layout

| Directory | Role |
|---|---|
| `lib/config/` | App config; env values injected via flutter_flavor |
| `lib/l10n/` | ARB files; `built/` is generated — do not edit |
| `lib/model/core/` | Core domain logic |
| `lib/model/entity/` | Domain entities (Participant, Payment, Transaction, …) |
| `lib/model/transport/` | DTOs (`@JsonSerializable`); `*.g.dart` are generated |
| `lib/model/usecase/` | Use cases |
| `lib/ui/core/` | Shared UI components |
| `lib/ui/<screen>/` | One directory per screen |
| `lib/ui/util/` | UI utilities |
| `test/` | Mirrors `lib/` layout |

## Flavors

| Entry point | Flavor |
|---|---|
| `lib/main_dev.dart` | dev |
| `lib/main_prd.dart` | prd |

## Architecture decisions

- `main_dev.dart` and `main_prd.dart` must remain thin entry points. Do not write external library implementations (Firebase, AdMob, etc.) directly in them. Limit initialization to `XxxUsecase.shared().initialize()` calls; keep implementation details in `model/usecase/`.

## Build sequence

```sh
flutter gen-l10n                        # generate l10n
flutter pub get
flutter pub run build_runner build      # generate *.g.dart
flutter analyze                         # must pass
flutter test
```

## Local CI verification

`azure-pipelines.yml` is the single source of truth for CI steps. Never
create a local script that duplicates its step list.

Before proposing a commit preview for changes touching any of `ios/`,
`android/`, `pubspec.yaml`, `l10n.yaml`, `firebase.json`, or
`azure-pipelines.yml`, run `/ci-preflight`. It reads the pipeline definition
and translates the build steps into locally runnable equivalents
(e.g. `flutter build ipa` → `flutter build ios --no-codesign`), so build
breakage is caught in minutes locally instead of after a one-hour CI run.

Deploy steps (Firebase App Distribution / Hosting, App Store, Play Store)
cannot be verified locally and remain CI-verified.

## Do not edit — generated files

- `lib/l10n/built/` — `flutter gen-l10n` output
- `lib/model/transport/*.g.dart` — `build_runner` output

## Environment

`lib/config/env.dart` is not tracked. Copy `lib/config/sample_env.dart`
to `lib/config/env.dart` and fill in real values before building.

## Design decisions

- State management: `setState` is sufficient. Riverpod is over-engineering for this app's scale.
  Each screen owns its own state; inter-screen data is passed via DTOs.
