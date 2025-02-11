fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios load_certs

```sh
[bundle exec] fastlane ios load_certs
```

provisioning profile読み取りlane

### ios add_device_to_profiles

```sh
[bundle exec] fastlane ios add_device_to_profiles
```

provisioning profileへの端末追加lane

### ios produce_certs

```sh
[bundle exec] fastlane ios produce_certs
```

provisioning profile生成lane

### ios upload_ipa_to_store

```sh
[bundle exec] fastlane ios upload_ipa_to_store
```

AppStore向けipaアップロードlane

### ios upload_aab_to_store

```sh
[bundle exec] fastlane ios upload_aab_to_store
```

PlayStore向けaabアップロードlane

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
