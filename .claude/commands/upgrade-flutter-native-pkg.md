# /upgrade-flutter-native-pkg — Upgrade a Flutter package with native (CocoaPods) dependencies

Upgrades a Flutter package that has CocoaPods native dependencies,
ensuring `pubspec.yaml`, `pubspec.lock`, and `ios/Podfile.lock` are all consistent before committing.

## Steps

### Step 1: Identify the target package and version

Confirm the package and target version with the user, then update `pubspec.yaml`.

```bash
flutter pub outdated
```

### Step 2: Resolve Dart dependencies

```bash
flutter pub get
flutter analyze
flutter test
```

All must pass. If any fail, report to the user and wait for instructions.

### Step 3: Identify and update the CocoaPods dependency

Find the Pod name from the plugin's podspec.

```bash
cat ios/.symlinks/plugins/<package-name>/ios/*.podspec | grep "s.name"
```

Update the identified Pod (prepend rbenv shims to PATH if using rbenv).

```bash
export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)"
cd ios && pod update <PodName>
```

### Step 4: Verify the iOS build

Build for device using the project's entry point and flavor.

```bash
export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)"
flutter build ios --no-codesign -t lib/main_dev.dart --flavor dev
```

- Confirm the build succeeds and the target warning/error is resolved.
- Confirm `ios/Podfile.lock` is updated via `git status`.

### Step 5: Commit

Stage `pubspec.yaml`, `pubspec.lock`, and `ios/Podfile.lock` together.
If folding into an existing commit, use rebase (confirm with the user first).

Suggested commit message format:

```
chore: update iOS Pod dependency for <package-name> <old-version> → <new-version>

Update <PodName> from <old-pod-version> to <new-pod-version> to satisfy
the requirements of <package-name> <new-version>.
```
