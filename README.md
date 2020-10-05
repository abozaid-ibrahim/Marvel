# Marvel

## Building and running the project (requirements).
* Swift 5.0+
* Xcode 11.5+
* iOS 13.0+

### General application frameworks
- RxSwift
- RxTest
- Swiftlint
# Getting Started
If this is your first time encountering swift/ios development,
Please follow [the instructions](https://developer.apple.com/support/xcode/) to setup Xcode and Swift on your Mac.
To setup cocoapods for dependency management, make use of [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started)

## Setup Configs
- Checkout master branch to run latest version
- Open the terminal.
- Navigate to the project root directory.
- Make sure you have cocoapods setup, then run: pod install
- Open the project by double clicking the `Marvel.xcworkspace` file
- Select the build scheme which can be found right after the stop button on the top left of the IDE
- [Command(cmd)] + R - Run app

## Architecture
This application uses the Model-View-ViewModel (refered to as MVVM) architecture,
the main purpose of the MVVM is to move the data state from the View to the ViewModel, 


## Structure

### SupportingFiles
- Group app shared fils, like appDelegate, assets,...etc

### Modules
- include seperate modules, Networking, Caching, Extensions...etc.

### Scenes
- Group of app scenes: heros view, and feed view
 
 ## Improvements

 * Improve code coverage
 * Create sticky header for the tableview.
 * Revisit the UI
 * Calculate the uitable view cell height dynamically
 
 ## Notes
 -  I intended to encapsulate the core data in seperate module, and keep my data classes not aware of caching mechanism 
 -  from performance wise, I didn't technically measure it, but I expect to be faster since we have almost zero nsmanaged object is up, 
 and live in the memory.
 
