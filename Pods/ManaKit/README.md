# ManaKit

[![CI Status](http://img.shields.io/travis/jovito-royeca/ManaKit.svg?style=flat)](https://travis-ci.org/jovito-royeca/ManaKit)
[![Version](https://img.shields.io/cocoapods/v/ManaKit.svg?style=flat)](http://cocoapods.org/pods/ManaKit)
[![License](https://img.shields.io/cocoapods/l/ManaKit.svg?style=flat)](http://cocoapods.org/pods/ManaKit)
[![Platform](https://img.shields.io/cocoapods/p/ManaKit.svg?style=flat)](http://cocoapods.org/pods/ManaKit)

A Core Data implementation of [MTGJSON](http://mtgjson.com/).

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

To access the Core Data database, you may use the `mainContext` of `ManaKit`:

```
let context = ManaKit.sharedInstance.dataStack!.mainContext
```

`ManaKit` also provides methods to get MTG images.

Specific images:

```
open func imageFromFramework(imageName: ImageName) -> UIImage?
```

Set images:

```
open func setImage(set: CMSet, rarity: CMRarity?) -> UIImage?
```

Casting Cost images:

```
open func manaImages(manaCost: String) -> [[String:UIImage]]
```

Card image:

```
open func downloadCardImage(_ card: CMCard, cropImage: Bool, completion: @escaping (_ card: CMCard, _ image: UIImage?, _ croppedImage: UIImage?, _ error: NSError?) -> Void)
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

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
