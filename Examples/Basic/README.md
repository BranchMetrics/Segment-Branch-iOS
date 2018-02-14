#  Segment-Branch Example

## Overview

This simple and not very thrilling example app simply adds the Branch SDK from the Segment Analytics Configuration
and logs shared analytics events at app open.

You can substitute your own key segment key for the one in the example to test in your environment.

There are some easy, quick implementation comments in the `BNCAppDelegate.m` source code that explain the
integration.

## Build Instructions

Install the CocoaPod from the command line:

```
cd Examples/Basic
pod install
pod update
```

Then open the `Segment-Branch.xcworkspace` workspace in Xcode, and choose 'Product > Run' from the menu.
