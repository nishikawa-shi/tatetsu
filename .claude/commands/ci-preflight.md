# /ci-preflight — Verify CI build steps locally before pushing

Reproduces the build and verification steps of `azure-pipelines.yml` on the
local machine, so that build breakage is caught in minutes locally instead of
after a roughly one-hour CI run.

`azure-pipelines.yml` is the single source of truth. Read it fresh on every
run and translate its steps on the fly — never hardcode or copy the step list
into this file or anywhere else, to avoid double maintenance.

An optional argument narrows the scope (e.g. `/ci-preflight qa` runs only the
qa stage, `/ci-preflight ios` runs only iOS build steps). Default is all
stages.

## Steps

### Step 1: Read the pipeline definition

Read `azure-pipelines.yml` and list every `- script:` / `- task:` step of
every stage. Classify each step:

| Category | How to recognize | Local handling |
|---|---|---|
| Environment setup | `DownloadSecureFile`, config tar inflation, `JavaToolInstaller`, `FlutterInstall`, gem / bundle / npm installs, `dart pub global activate`, `fastlane load_certs` | Skip — the local machine is assumed provisioned. If a later step fails due to a missing tool, report that |
| Verification / build | `flutter gen-l10n`, `flutter pub get`, `build_runner`, `flutter analyze`, launcher icons, `FlutterTest@0`, `flutter build ...` | Run locally, translated per Step 2 |
| Deploy | `firebase appdistribution:distribute`, `firebase deploy`, `fastlane upload_*` | Never run — report as CI-only |

### Step 2: Translate build commands for local execution

- Strip the `$FLUTTERTOOLPATH/` prefix and use the local `flutter`.
- `flutter build ipa --flavor <F> -t <T> --export-options-plist=<P>` →
  `flutter build ios --no-codesign --flavor <F> -t <T>`.
  Signing and ipa export require CI-managed certificates, but
  `--no-codesign` still runs every Xcode script build phase (FlutterFire
  symbol upload etc.), which is where CI-only breakage has historically
  lived in this project.
- `FlutterTest@0` → `flutter test`.
- Drop `--build-number=$(...)` and any other Azure `$(...)` variables.
- Other build commands (`apk`, `appbundle`, `web`) run as-is minus Azure
  variables.
- Before any iOS build step, put rbenv on PATH:

```bash
export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)"
```

### Step 3: Run

Run the translated steps in pipeline order. Deduplicate steps that are
identical across stages (e.g. `gen-l10n`, `pub get`, `build_runner`) so each
runs once. Stop at the first failure.

### Step 4: Report

Report a table with: pipeline step name, local command, result (pass / fail /
skipped-setup / CI-only). On failure, include the error output and stop — do
not push or propose a commit preview until the failure is resolved.
