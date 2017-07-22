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
        dataSource = getDataSource(nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kIASKAppSettingChanged), object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SetViewController.updateData(_:)), name: NSNotification.Name(rawValue: kIASKAppSettingChanged), object: nil)
        
        rightMenuButton.image = UIImage.fontAwesomeIcon(name: .gear, textColor: UIColor.white, size: CGSize(width: 30, height: 30))
        rightMenuButton.title = nil
        tableView.register(ManaKit.sharedInstance.nibFromBundle("CardTableViewCell"), forCellReuseIdentifier: "CardCell")
    }

    // MARK: Custom methods
    func getDataSource(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>?) -> DATASource? {
        var request:NSFetchRequest<NSFetchRequestResult>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            request = NSFetchRequest(entityName: "CMCard")
            let defaults = defaultsValue()
            
            request!.sortDescriptors = [NSSortDescriptor(key: defaults["setSortBy"] as? String, ascending: (defaults["setOrderBy"] as? Bool)!)]
            request!.predicate = NSPredicate(format: "set.code = %@", set!.code!)
        }
        
        let dataSource = DATASource(tableView: tableView, cellIdentifier: "CardCell", fetchRequest: request!, mainContext: ManaKit.sharedInstance.dataStack!.mainContext, configuration: { cell, item, indexPath in
            if let card = item as? CMCard,
                let cardCell = cell as? CardTableViewCell {
                
                cardCell.card = card
                cardCell.updateDataDisplay()
            }
        })
        
        return dataSource
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
            tableView.reloadData()
        }
    }
    
    func defaultsValue() -> [String: Any] {
        var values = [String: Any]()
        var setSortBy = "releaseDate"
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
