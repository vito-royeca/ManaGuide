//
//  SetViewController.swift
//  ManaGuide
//
//  Created by Jovito Royeca on 21/07/2017.
//  Copyright © 2017 Jovito Royeca. All rights reserved.
//

import UIKit
import DATASource
import FontAwesome_swift
import InAppSettingsKit
import ManaKit

class SetViewController: BaseViewController {

    // MARK: Variables
    var set:CMSet?
    var dataSource: DATASource?
    var sectionIndexTitles = [String]()

    // MARK: Outlets
    @IBOutlet weak var rightMenuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Actions
    @IBAction func showRightMenuAction(_ sender: UIBarButtonItem) {
        showSettingsMenu(file: "Set")
    }
    
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kIASKAppSettingChanged), object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SetViewController.updateData(_:)), name: NSNotification.Name(rawValue: kIASKAppSettingChanged), object: nil)
        
        rightMenuButton.image = UIImage.fontAwesomeIcon(name: .gear, textColor: UIColor.white, size: CGSize(width: 30, height: 30))
        rightMenuButton.title = nil
        tableView.register(ManaKit.sharedInstance.nibFromBundle("CardTableViewCell"), forCellReuseIdentifier: "CardCell")
        
        dataSource = getDataSource(nil)
        updateSectionIndexTitles()
    }

    // MARK: Custom methods
    func getDataSource(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>?) -> DATASource? {
        var request:NSFetchRequest<NSFetchRequestResult>?
        let defaults = defaultsValue()
        let setSortBy = defaults["setSortBy"] as! String
        let setOrderBy = defaults["setOrderBy"] as! Bool
        var sectionName:String?
        
        switch setSortBy {
        case "name":
            sectionName = "nameSection"
        case "mciNumber":
            sectionName = "numberSection"
        default:
            ()
        }
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            request = NSFetchRequest(entityName: "CMCard")
            
            request!.sortDescriptors = [NSSortDescriptor(key: sectionName!, ascending: setOrderBy),
                                        NSSortDescriptor(key: setSortBy, ascending: setOrderBy)]
            request!.predicate = NSPredicate(format: "set.code = %@", set!.code!)
        }
        
        let dataSource = DATASource(tableView: tableView, cellIdentifier: "CardCell", fetchRequest: request!, mainContext: ManaKit.sharedInstance.dataStack!.mainContext, sectionName: sectionName, configuration: { cell, item, indexPath in
            if let card = item as? CMCard,
                let cardCell = cell as? CardTableViewCell {
                
                cardCell.card = card
                cardCell.updateDataDisplay()
//                if let types_ = card.types_ {
//                    for type in types_.allObjects as! [CMCardType] {
//                        print("\(card.name!) - \(type.name!)")
//                    }
//                }
            }
        })
    
        dataSource.delegate = self
        return dataSource
    }
    
    func updateSectionIndexTitles() {
        if let dataSource = dataSource {
            let cards = dataSource.all() as [CMCard]
            sectionIndexTitles = [String]()
            
            let defaults = defaultsValue()
            let setSortBy = defaults["setSortBy"] as! String
            
            switch setSortBy {
            case "name":
                for card in cards {
                    if !sectionIndexTitles.contains(card.nameSection!) {
                        sectionIndexTitles.append(card.nameSection!)
                    }
                }
            default:
                ()
            }
        }
        
        sectionIndexTitles.sort()
    }
    
    func updateData(_ notification: Notification) {
        if let userInfo = notification.userInfo as? [String: Any] {
            let defaults = defaultsValue()
            var setSortBy = defaults["setSortBy"] as! String
            var setOrderBy = defaults["setOrderBy"] as! Bool
//            var setDisplayBy = defaults["setDisplayBy"] as! NSNumber
//            var setShow = defaults["setShow"] as! NSNumber
            
            if let value = userInfo["setSortBy"] as? NSNumber {
                switch value {
                case 1:
                    setSortBy = "name"
                case 2:
                    setSortBy = "mciNumber"
                default:
                    ()
                }
            }
            
            if let value = userInfo["setOrderBy"] as? NSNumber {
                switch value {
                case 1:
                    setOrderBy = true
                case 2:
                    setOrderBy = false
                default:
                    ()
                }
            }
            
            // TODO: implement these
//            if let value = userInfo["setDisplayBy"] as? NSNumber {
//                setDisplayBy = value
//            }
//            
//            if let value = userInfo["setShow"] as? NSNumber {
//                setShow = value
//            }
            
            let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CMCard")
            request.predicate = NSPredicate(format: "set.code = %@", set!.code!)
            request.sortDescriptors = [NSSortDescriptor(key: setSortBy, ascending: setOrderBy)]

            dataSource = getDataSource(request)
            updateSectionIndexTitles()
            tableView.reloadData()
        }
    }
    
    func defaultsValue() -> [String: Any] {
        var values = [String: Any]()
        var setSortBy = "name"
        var setOrderBy = false
        var setDisplayBy = NSNumber(value: 1)
        var setShow = NSNumber(value: 1)
        
        if let value = UserDefaults.standard.value(forKey: "setSortBy") as? NSNumber {
            switch value {
            case 1:
                setSortBy = "name"
            case 2:
                setSortBy = "mciNumber"
            default:
                ()
            }
        }
        
        if let value = UserDefaults.standard.value(forKey: "setOrderBy") as? NSNumber {
            switch value {
            case 1:
                setOrderBy = true
            case 2:
                setOrderBy = false
            default:
                ()
            }
        }
        
        if let value = UserDefaults.standard.value(forKey: "setDisplayBy") as? NSNumber {
            setDisplayBy = value
        }
        
        if let value = UserDefaults.standard.value(forKey: "setShow") as? NSNumber {
            setShow = value
        }
        
        values["setSortBy"] = setSortBy
        values["setOrderBy"] = setOrderBy
        values["setDisplayBy"] = setDisplayBy
        values["setShow"] = setShow
        
        return values
    }

}

// MARK: UITableViewDelegate
extension SetViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCardTableViewCellHeight
    }
}

// MARK: DATASourceDelegate
extension SetViewController : DATASourceDelegate {
    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
    func sectionIndexTitlesForDataSource(_ dataSource: DATASource, tableView: UITableView) -> [String] {
        return sectionIndexTitles
    }
    
    // tell table which section corresponds to section title/index (e.g. "B",1))
    func dataSource(_ dataSource: DATASource, tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        let defaults = defaultsValue()
        let setsOrderBy = defaults["setOrderBy"] as! Bool
        var sectionIndex = 0
        
        // TODO: fix this!!!
        print("\(title) / \(index)")
        
        if setsOrderBy {
            sectionIndex = index
        } else {
            sectionIndex = (sectionIndexTitles.count - 1) - index
        }
        
        return sectionIndex
    }
}
