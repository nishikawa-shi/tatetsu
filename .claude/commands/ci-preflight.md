# /ci-preflight — Verify CI build steps locally before pushing

Reproduces the build and verification steps of `.github/workflows/ci.yml` on
the local machine, so that build breakage is caught in minutes locally instead
of after a roughly one-hour CI run.

`.github/workflows/ci.yml` is the single source of truth. Read it fresh on
every run and translate its steps on the fly — never hardcode or copy the step
list into this file or anywhere else, to avoid double maintenance.

An optional argument narrows the scope (e.g. `/ci-preflight qa` runs only the
qa job, `/ci-preflight ios` runs only iOS build steps). Default is all jobs.

## Steps

### Step 1: Read the workflow definition

Read `.github/workflows/ci.yml` and list every `- run:` / `- uses:` step of
every job. Classify each step:

| Category | How to recognize | Local handling |
|---|---|---|
| Environment setup | `actions/checkout`, configs tar inflation, `actions/setup-java`, `subosito/flutter-action`, `ruby/setup-ruby`, npm installs, `dart pub global activate`, `fastlane load_certs` / match | Skip — the local machine is assumed provisioned. If a later step fails due to a missing tool, report that |
| Verification / build | `flutter gen-l10n`, `flutter pub get`, `build_runner`, `flutter analyze`, launcher icons, `flutter test`, `flutter build ...` | Run locally, translated per Step 2 |
| Deploy | `firebase appdistribution:distribute`, `firebase deploy` / `hosting:channel:deploy`, `fastlane upload_*` | Never run — report as CI-only |

### Step 2: Translate build commands for local execution

- `flutter build ipa --flavor <F> -t <T> --export-options-plist=<P>` →
  `flutter build ios --no-codesign --flavor <F> -t <T>`.
  Signing and ipa export require CI-managed certificates, but
  `--no-codesign` still runs every Xcode script build phase (FlutterFire
  symbol upload etc.), which is where CI-only breakage has historically
  lived in this project.
- Drop `--build-number="$..."` and any other value that comes from
  `${{ ... }}` expressions or `$GITHUB_ENV`-derived variables.
- Other build commands (`apk`, `appbundle`, `web`) run as-is minus those
  CI variables.
- Before any iOS build step, put rbenv on PATH:

```bash
export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)"
```

### Step 3: Run

Run the translated steps in workflow order. Deduplicate steps that are
identical across jobs (e.g. `gen-l10n`, `pub get`, `build_runner`) so each
runs once. Stop at the first failure.

### Step 4: Report

Report a table with: pipeline step name, local command, result (pass / fail /
skipped-setup / CI-only). On failure, include the error output and stop — do
not push or propose a commit preview until the failure is resolved.
