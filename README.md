# Marvel

## Building And Running The Project (Requirements)
* Swift 5.0+
* Xcode 11.5+
* iOS 13.0+

### General Application Frameworks
- RxSwift: [Reactive framework](https://github.com/ReactiveX/RxSwift)
# Getting Started
If this is your first time encountering swift/ios development, please follow [the instructions](https://developer.apple.com/support/xcode/) to setup Xcode and Swift on your Mac. And to setup cocoapods for dependency management, make use of [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started)
-checkout Master branch to run latest version
## Setup Configs
* Open the project by double clicking the `Marvel.xcworkspace` file
```
// App Settings
APP_NAME = Marvel
PRODUCT_BUNDLE_IDENTIFIER = com.abuzeid.Marvel

#targets:
* Marvel
* MarvelTests
* MarvelUITests

```


# In your terminal, go to the project root directory, make sure you have cocoapods setup, then run:
pod install

# Build and or run application by doing:
* Select the build scheme which can be found right after the stop button on the top left of the IDE
* [Command(cmd)] + B - Build app
* [Command(cmd)] + R - Run app

## Architecture
This application uses the Model-View-ViewModel (refered to as MVVM) architecture,
the main purpose of the MVVM is to move the data state from the View to the ViewModel, 


## Structure

### SupportingFiles
This is to group app shared fils, like appDelegate, assets,...etc

### Modules
- include seperate modules, Networking, extensions...etc.

### Scenes
This is for group of app scenes: movies view, and details view


## Add New Feature
 * you could  add new feature by folling OneFlow Model  (https://www.endoflineblog.com/oneflow-a-git-branching-model-and-workflow)
 * to start new featre, checkout from master, your branch should be under feature group
 
 ## Improvements

 * reach 100% code coverage
