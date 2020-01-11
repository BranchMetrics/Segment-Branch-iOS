# Branch-Segment-iOS Change Log

- v0.1.20
  * Update to Branch iOS SDK 0.31.x
  * Fix broken 0.1.19 release
  * Note, we recommend using data export integration instead.

- v0.1.19
  * Update to Branch iOS SDK 0.30.x
  * Add Carthage support

- v0.1.18
  * Remove dependency on BNCThreads.
  * Pin to minor version in podspec.

- v0.1.17
  * Use the passed Segment instance in the Segment-Branch kit rather than the global one.

- v0.1.16
  * Updated the documentation.
  * Updated the 'Fortune' example with docs and Segment calls.

- v0.1.15
  * Fixed an issue where the Branch integration was inadvertently stripping values from Segment events.

- v0.1.14
  * Automatically add the `$segment_anonymous_id` to open/install requests and event logging.

- v0.1.13
  * Prevent double opens from being reported to analytics.

- v0.1.12
  * Updated the Branch SDK to version 0.25.x.

- v0.1.11
  * Updated the Branch SDK to version 0.25.x.
  * Update the projects for Xcode 9.3.1.
  * Remove some debug code in the Segment-Branch interface.

- v0.1.10
  * Updated the Branch SDK to version 0.23.5.

- v0.1.9
  * Updated the interface so that Segment events are also tracked in the Branch dashboard.
  * Added a better example: Example/Fortune.
  * Updated the Branch SDK to version 0.23.4.

- v0.1.8
  * Updated the Branch SDK to version 0.21.16.

- v0.1.7
  * Updated the Branch SDK to version 0.21.11.

- v0.1.6
  * Updated the Branch SDK to version 0.21.9.

- v0.1.5
  * Fixed the release script.

- v0.1.4
  * Updated the Branch SDK to version 0.20.2.

- v0.1.3
  * Updated the Branch SDK to version 0.19.5.
  * Updated the example for Xcode 9.
  * Added documentation and a README.md file to the example.

- v0.1.2
  * Conform to more Segment handlers
  * `receivedRemoteNotification:` is now handled.
  * `continueUserActivity:` is now handled.
  * `openURL:options:` is now handled.

- v0.1.1
  * Update Segment iOS reference

- v0.1.01
  * Update key

- v0.1.0
  * First release
