# ManaKit

[![CI Status](http://img.shields.io/travis/jovito-royeca/ManaKit.svg?style=flat)](https://travis-ci.org/jovito-royeca/ManaKit)
[![Version](https://img.shields.io/cocoapods/v/ManaKit.svg?style=flat)](http://cocoapods.org/pods/ManaKit)
[![License](https://img.shields.io/cocoapods/l/ManaKit.svg?style=flat)](http://cocoapods.org/pods/ManaKit)
[![Platform](https://img.shields.io/cocoapods/p/ManaKit.svg?style=flat)](http://cocoapods.org/pods/ManaKit)

A database of Magic: The Gathering cards. Includes prices and images. This is the  successor to the [Decktracker](https://github.com/jovito-royeca/Decktracker) project.

## Usage

The singleton `ManaKit` class provides API methods for setting up the Core Data database, getting images embedded in the framework, and a lot more.

Set up ManaKit in your app delegate class:

````
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // Override point for customization after application launch.
    ManaKit.sharedInstance.setupResources()
        
    return true
}
    
````

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ManaKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ManaKit"
```

## Author

Jovito Royeca
jovit.royeca@gmail.com

## License

ManaKit is available under the MIT license. See the LICENSE file for more info.
