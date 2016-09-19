# Keychain Error Demo

This demo project uses the Keychain store, load and delete credentials. It works as expected with iOS 9 and on a device with iOS 10. But when the included tests are run with iOS 10 the OSStatus is -34018 which indicates a missing entitlement.

It is not clear why this status is returned. The unexpected status is returned when the `SecItemDelete` function is used. The expected results are `noErr` or `errSecItemNotFound`.

There appears to be a history of this status being returned unexpectedly with previous versions of iOS.

* https://forums.developer.apple.com/thread/4743
* https://github.com/DinosaurDad/Keychain-34018

# How to Test

The included tests demonstrate the issue. Running tests with a device running iOS 10 appears to work. Running with an iOS Simulator with iOS 10 fails. The tests succeed with iOS 9 with the Simulator.

# License

MIT

# Author

Brennan Stehling - @brennansv
