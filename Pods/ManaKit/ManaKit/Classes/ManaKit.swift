//
//  Manakit.swift
//  ManaKit
//
//  Created by Jovito Royeca on 11/04/2017.
//  Copyright © 2017 Jovito Royeca. All rights reserved.
//

import UIKit
import DATASource
import SSZipArchive
import Sync


public let kMTGJSONVersion      = "3.9.3"
public let kMTGJSONVersionKey   = "kMTGJSONVersionKey"
public let kImagesVersion       = kMTGJSONVersion
public let kImagesVersionKey    = "kImagesVersionKey"
public let kCardImageSource     = "http://magiccards.info"
public let kEightEditionRelease = "2003-07-28"

public enum ImageName: String {
    case cardCircles       = "Card_Circles",
    cardBackCropped        = "cardback-crop-hq",
    cardBack               = "cardback-hq",
    collectorsCardBack     = "collectorscardback-hq",
    cropBack               = "cropback-hq",
    grayPatterned          = "Gray_Patterned_BG",
    intlCollectorsCardBack = "internationalcollectorscardback-hq"
}

// Some image constants
public let kImageCardCircles            = "Card_Circles"
public let kImageCardBackCropped        = "cardback-crop-hq"
public let kImageCardBack               = "cardback-hq"
public let kImageCollectorsCardBack     = "collectorscardback-hq"
public let kImageCropBack               = "cropback-hq"
public let kImageGrayPatterned          = "Gray_Patterned_BG"
public let kImageIntlCollectorsCardBack = "internationalcollectorscardback-hq"

@objc(ManaKit)
open class ManaKit: NSObject {
    // MARK: - Shared Instance
    open static let sharedInstance = ManaKit()
    
    // MARK: Variables
    fileprivate var _dataStack:DataStack?
    open var dataStack:DataStack? {
        get {
            if _dataStack == nil {
                guard let bundleURL = Bundle(for: ManaKit.self).url(forResource: "ManaKit", withExtension: "bundle") else { return nil }
                guard let bundle = Bundle(url: bundleURL) else { return nil }
                guard let momURL = bundle.url(forResource: "ManaKit", withExtension: "momd") else { return nil }
                guard let objectModel = NSManagedObjectModel(contentsOf: momURL) else { return nil }
                _dataStack = DataStack(model: objectModel, storeType: .sqLite)
            }
            return _dataStack
        }
    }
    
    /*
     * Example path: "/images/set/2ED/C/48.png"
     */
    open func imageFromFramework(imageName: ImageName) -> UIImage? {
        let bundle = Bundle(for: ManaKit.self)
        let subDir = "images"
        let resource = imageName.rawValue
        
        if let url = bundle.url(forResource: resource, withExtension: "png", subdirectory: subDir) {
            let data = try! Data(contentsOf: url)
            return UIImage(data: data)
        }
        
        return nil
    }
    
    open func setImage(set: CMSet, rarity: CMRarity?) -> UIImage? {
        let bundle = Bundle(for: ManaKit.self)
        var prefix = "C"
        
        if let rarity = rarity {
            let index = rarity.name!.index(rarity.name!.startIndex, offsetBy: 1)
            prefix = rarity.name!.substring(to: index)
            
            if rarity.name == "Basic Land" {
                prefix = "C"
            }
        }
    
        var image = UIImage(named: "\(set.code!)-\(prefix)", in: bundle, compatibleWith: nil)
        
        if image == nil {
            image = UIImage(named: "DEFAULT-\(prefix)", in: bundle, compatibleWith: nil)
        }
        
        return image
    }
    
    open func manaImages(manaCost: String) -> [[String:UIImage]] {
        let bundle = Bundle(for: ManaKit.self)
        
        var array = [[String:UIImage]]()
        let mc = manaCost.replacingOccurrences(of: "{", with: "")
            .replacingOccurrences(of: "}", with: " ")
            .replacingOccurrences(of: "/", with: "")
        let manaArray = mc.components(separatedBy: " ")
        
        for mana in manaArray {
            if mana.characters.count == 0 {
                continue
            }
            
            var image = UIImage(named: "mana-\(mana)", in: bundle, compatibleWith: nil)
            
            // fix for dual manas
            if image == nil {
                if mana.characters.count > 1 {
                    let reversedMana = String(mana.characters.reversed())

                    image = UIImage(named: "mana-\(reversedMana)", in: bundle, compatibleWith: nil)
                }
            }
            
            if let image = image {
                array.append([mana:image])
            }
        }
        
        return array
    }
    
    open func symbolImage(name: String) -> UIImage? {
        let bundle = Bundle(for: ManaKit.self)
        
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    open func nibFromBundle(_ name: String) -> UINib {
        let bundle = Bundle(for: ManaKit.self)
        return UINib(nibName: name, bundle: bundle)
    }
    
    open func setupResources() {
        copyDatabaseFile()
        loadCustomFonts()
    }
    
    func copyDatabaseFile() {
        let bundle = Bundle(for: ManaKit.self)
        
        if let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
            let sourcePath = bundle.path(forResource: "ManaKit.sqlite", ofType: "zip"),
            let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            
            var willCopy = true

            // Check if we have old files
            let targetPath = "\(docsPath)/\(bundleName).sqlite"
            willCopy = !FileManager.default.fileExists(atPath: targetPath)
            
            // Check if we saved the version number
            if let version = UserDefaults.standard.object(forKey: kMTGJSONVersionKey) as? String {
                willCopy = version != kMTGJSONVersion
            }
            
            if willCopy {
                // Remove old database files
                for file in try! FileManager.default.contentsOfDirectory(atPath: docsPath) {
                    let path = "\(docsPath)/\(file)"
                    if file.hasPrefix(bundleName) {
                        try! FileManager.default.removeItem(atPath: path)
                    }
                }
                
                // Unzip
                SSZipArchive.unzipFile(atPath: sourcePath, toDestination: docsPath)
                
                // rename
                try! FileManager.default.moveItem(atPath: "\(docsPath)/ManaKit.sqlite", toPath: targetPath)
                
                // skip from iCloud backups!
                var targetURL = URL(fileURLWithPath: targetPath)
                var resourceValues = URLResourceValues()
                resourceValues.isExcludedFromBackup = true
                try! targetURL.setResourceValues(resourceValues)
                
                // Save the version
                UserDefaults.standard.set(kMTGJSONVersion, forKey: kMTGJSONVersionKey)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func loadCustomFonts() {
        let bundle = Bundle(for: ManaKit.self)
        
        if let urls = bundle.urls(forResourcesWithExtension: "ttf", subdirectory: "fonts") {
            for url in urls {
                let data = try! Data(contentsOf: url)
                let error: UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
                guard let provider = CGDataProvider(data: data as CFData) else { return }
                let font = CGFont(provider)
                
                if !CTFontManagerRegisterGraphicsFont(font, error) {
                    if let unmanagedError = error?.pointee {
                        if let errorDescription = CFErrorCopyDescription(unmanagedError.takeUnretainedValue()) {
                            print("Failed to load font: \(errorDescription)")
                        }
                    }
                }
            }
        }
    }
    
    func unpackImages() {
        if let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            var willCopy = true
            
            let targetPath = "\(cachePath)/images"
            willCopy = !FileManager.default.fileExists(atPath: targetPath)
            
            // Check if we saved the version number
            if let version = UserDefaults.standard.object(forKey: kImagesVersionKey) as? String {
                willCopy = version != kImagesVersion
            }
            
            if willCopy {
                let bundle = Bundle(for: ManaKit.self)
                
                // Remove old images dir
                if FileManager.default.fileExists(atPath: targetPath) {
                    try! FileManager.default.removeItem(atPath: targetPath)
                }
                
                if let sourcePath = bundle.path(forResource: "images", ofType: "zip") {
                    // Unzip
                    try! SSZipArchive.unzipFile(atPath: sourcePath, toDestination: cachePath, overwrite: true, password: nil)
                    
                    // Save the version
                    UserDefaults.standard.set(kImagesVersion, forKey: kImagesVersionKey)
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    // MARK: Database methods
    open func findOrCreateObject(_ entityName: String, objectFinder: [String: AnyObject]?) -> NSManagedObject? {
        var object:NSManagedObject?
        var predicate:NSPredicate?
        var fetchRequest:NSFetchRequest<NSFetchRequestResult>?
        
        if let objectFinder = objectFinder {
            for (key,value) in objectFinder {
                if predicate != nil {
                    predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!, NSPredicate(format: "%K == %@", key, value as! NSObject)])
                } else {
                    predicate = NSPredicate(format: "%K == %@", key, value as! NSObject)
                }
            }

            fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest!.predicate = predicate
        }
        
        if let fetchRequest = fetchRequest {
            if let m = try! dataStack?.mainContext.fetch(fetchRequest).first as? NSManagedObject {
                object = m
            } else {
                if let desc = NSEntityDescription.entity(forEntityName: entityName, in: dataStack!.mainContext) {
                    object = NSManagedObject(entity: desc, insertInto: dataStack?.mainContext)
                    try! dataStack?.mainContext.save()
                }
            }
        } else {
            if let desc = NSEntityDescription.entity(forEntityName: entityName, in: dataStack!.mainContext) {
                object = NSManagedObject(entity: desc, insertInto: dataStack?.mainContext)
                try! dataStack?.mainContext.save()
            }
        }
        
        return object
    }
    
    // MARK: Miscellaneous methods
    open func urlOfCard(_ card: CMCard) -> URL? {
        var url:URL?
        
        if let set = card.set {
            if let code = set.magicCardsInfoCode ?? set.code,
                let number = card.number ?? card.mciNumber {
                let path = "\(kCardImageSource)/scans/en/\(code.lowercased())/\(number).jpg"
                url = URL(string: path)
            }
        }
        
        return url
    }
    
    open func downloadCardImage(_ card: CMCard, cropImage: Bool, completion: @escaping (_ card: CMCard, _ image: UIImage?, _ croppedImage: UIImage?, _ error: NSError?) -> Void) {
        
        if let url = urlOfCard(card) {
            NetworkingManager.sharedInstance.downloadImage(url, completionHandler: {(_ origURL: URL?, _ image: UIImage?, _ error: NSError?) -> Void in
            
                if let error = error {
                    completion(card, nil, nil, error)
                } else {
                    completion(card, image, cropImage ? self.crop(image!, ofCard: card) : nil, nil)
                }
            })
        } else {
            completion(card, nil, nil, NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "magicCardsInfoCode not found"]))
        }
    }
    
    open func isModern(_ card: CMCard) -> Bool {
        var isModern = false
        
        if let releaseDate = card.set!.releaseDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let eightEditionDate = formatter.date(from: kEightEditionRelease),
                let setReleaseDate = formatter.date(from: releaseDate) {
                isModern = setReleaseDate.compare(eightEditionDate) == .orderedDescending ||
                           setReleaseDate.compare(eightEditionDate) == .orderedSame
            }
        }
        
        return isModern
    }
    
    open func crop(_ image: UIImage, ofCard card: CMCard) -> UIImage? {
        if let dir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            let path = "\(dir)/crop/\(card.set!.code!)"
            
            if let number = card.number ?? card.mciNumber {
                let cropPath = "\(path)/\(number)-crop.jpg"
                
                if FileManager.default.fileExists(atPath: cropPath) {
                    return UIImage(contentsOfFile: cropPath)
                } else {
                    let width = image.size.width * 3/4
                    let rect = CGRect(x: (image.size.width-width) / 2,
                                      y: isModern(card) ? 45 : 40,
                                      width: width,
                                      height: width-60)
                    
                    let imageRef = image.cgImage!.cropping(to: rect)
                    let croppedImage = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
                    
                    
                    // write to file
                    if !FileManager.default.fileExists(atPath: path)  {
                        try! FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                    }
                    try! UIImageJPEGRepresentation(croppedImage, 1.0)?.write(to: URL(fileURLWithPath: cropPath))
                    
                    return UIImage(contentsOfFile: cropPath)
                }
            }
        }
        
        return nil
    }
    
    open func cardImage(_ card: CMCard) -> UIImage? {
        if let url = urlOfCard(card) {
            return NetworkingManager.sharedInstance.localImageFromURL(url)
        } else {
            return nil
        }
    }
    
    open func croppedImage(_ card: CMCard) -> UIImage? {
        if let dir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            let path = "\(dir)/crop/\(card.set!.code!)"
            
            if let number = card.number ?? card.mciNumber {
                let cropPath = "\(path)/\(number)-crop.jpg"
                
                if FileManager.default.fileExists(atPath: cropPath) {
                    return UIImage(contentsOfFile: cropPath)
                }
            }
        }
        
        return nil
    }
}
