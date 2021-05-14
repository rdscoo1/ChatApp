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
### ios build_for_testing
```
fastlane ios build_for_testing
```
Setting dependencies and building app without tests
### ios run_tests_without_building
```
fastlane ios run_tests_without_building
```
Run tests on built app
### ios build_and_run_tests
```
fastlane ios build_and_run_tests
```
Both build app and run tests

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
