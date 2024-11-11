# NextBrokes
*Next to go racing? That's NextBrokes!*

<img src="NextBrokes/Preview%20Content/repo-image.png" width="1000" title="hover text">

## Description
This application uses `api.neds.com` to retrieve and display upcoming races, with optional filtering.

**Frameworks**: SwiftUI, Combine, Swift Concurrency

**Platforms**: iOS 15+, iPadOS 15+

**Architecture**: MVVM + CLEAN

## Setup

To run the application:
1. Download and install [Xcode](https://apps.apple.com/au/app/xcode/id497799835?mt=12)
2. Install [SwiftLint](https://github.com/realm/SwiftLint#installation)
3. Clone the repo, then open and run it in Xcode

## Discussion

### Architecture
As mentioned, the architecture is MVVM+Clean. This has also been implemented alongside feature modules.

The key feature module is `FeatureRacing`, which encapsulates features related to racing. Potentially the responsibility is too broad, hard to tell without further domain knowledge.

A benefit of the setup of the features package is its separation of concerns via the layer of Data, Domain, and Presentation. This makes it easy to ensure one layer is flowing to the next, via the imports, and that a layer isn't being skipped or being imported elsewhere.

Lastly, the two core packages `CoreDesign` and `CoreNetworking`, represent the design system package and networking package. These are fundamental to the app and any feature modules, and provide key building blocks.

### Implementation
The app works for both iPhone and iPad seamlessly, taking advantage of the additional room on iPad.

Races are automatically refreshed when old races are removed, ensuring up-to-date information for the user without any input, and minimal requests to the server.

Various errors have been handled, to ensure the app doesn't crash and the user is provided with relevant feedback.

### Design
Ease of use is key, along with a focus on the next race and when it starts. As mentioned, the races automatically refresh so the user is always up-to-date.

The design emphasises the countdown, creating a sense of anticipation of a starting race by changing the countdown colour as the start time approaches, begins, and passes.

Finally, filtering is easy and out of the way via an easy-to-tap button at the bottom of the device, which (on supported devices) opens a detented sheet that allows real-time filtering where the results can be seen in the background.
