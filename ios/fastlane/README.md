fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios load_certs
```
fastlane ios load_certs
```
provisioning profile読み取りlane
### ios add_device_to_profiles
```
fastlane ios add_device_to_profiles
```
provisioning profileへの端末追加lane
### ios produce_certs
```
fastlane ios produce_certs
```
provisioning profile生成lane

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
