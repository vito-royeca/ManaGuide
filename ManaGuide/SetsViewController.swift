//
//  SetsViewController.swift
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

class SetsViewController: BaseViewController {

    // MARK: Variables
    var dataSource: DATASource?

    // MARK: Outlets
    @IBOutlet weak var rightMenuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: actions
    @IBAction func rightMenuAction(_ sender: UIBarButtonItem) {
        showSettingsMenu(file: "Sets")
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = getDataSource(nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kIASKAppSettingChanged), object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SetsViewController.updateData(_:)), name: NSNotification.Name(rawValue: kIASKAppSettingChanged), object: nil)
        
        rightMenuButton.image = UIImage.fontAwesomeIcon(name: .gear, textColor: UIColor.white, size: CGSize(width: 30, height: 30))
        rightMenuButton.title = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSet" {
            if let dest = segue.destination as? SetViewController,
                let set = sender as? CMSet {
                
                dest.set = set
                dest.title = set.name
            }
        }
    }

    // MARK: Custom methods
    func getDataSource(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>?) -> DATASource? {
        var request:NSFetchRequest<NSFetchRequestResult>?
        
        if let fetchRequest = fetchRequest {
            request = fetchRequest
        } else {
            request = NSFetchRequest(entityName: "CMSet")
            let defaults = defaultsValue()
            
            request!.sortDescriptors = [NSSortDescriptor(key: defaults["setsSortBy"] as? String, ascending: (defaults["setsOrderBy"] as? Bool)!)]
        }
        
        let dataSource = DATASource(tableView: tableView, cellIdentifier: "SetCell", fetchRequest: request!, mainContext: ManaKit.sharedInstance.dataStack!.mainContext, configuration: { cell, item, indexPath in
            if let set = item as? CMSet {
                
                if let setIconView = cell.contentView.viewWithTag(100) as? UIImageView {
                    setIconView.image = ManaKit.sharedInstance.setImage(set: set, rarity: nil)
                }
                if let label = cell.contentView.viewWithTag(200) as? UILabel {
                    label.text = set.name
                    label.adjustsFontSizeToFitWidth = true
                }
                if let label = cell.contentView.viewWithTag(300) as? UILabel {
                    label.text = set.code
                }
                if let label = cell.contentView.viewWithTag(400) as? UILabel {
                    label.text = set.releaseDate
                }
                if let label = cell.contentView.viewWithTag(500) as? UILabel {
                    label.text = "\(set.cards!.allObjects.count) cards"
                }
            }
        })
        
        return dataSource
    }

    func updateData(_ notification: Notification) {
        if let userInfo = notification.userInfo as? [String: Any] {
            let defaults = defaultsValue()
            var setsSortBy = defaults["setsSortBy"] as! String
            var setsOrderBy = defaults["setsOrderBy"] as! Bool
            
            if let value = userInfo["setsSortBy"] as? NSNumber {
                switch value {
                case 1:
                    setsSortBy = "releaseDate"
                case 2:
                    setsSortBy = "name"
                case 3:
                    setsSortBy = "type_.name"
                default:
                    ()
                }
            }
            
            if let value = userInfo["setsOrderBy"] as? NSNumber {
                switch value {
                case 1:
                    setsOrderBy = true
                case 2:
                    setsOrderBy = false
                default:
                    ()
                }
            }
            
            let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CMSet")
            request.sortDescriptors = [NSSortDescriptor(key: setsSortBy, ascending: setsOrderBy)]
            
            dataSource = getDataSource(request)
            tableView.reloadData()
        }
    }
    
    func defaultsValue() -> [String: Any] {
        var values = [String: Any]()
        var setsSortBy = "releaseDate"
        var setsOrderBy = false
        
        if let value = UserDefaults.standard.value(forKey: "setsSortBy") as? NSNumber {
            switch value {
            case 1:
                setsSortBy = "releaseDate"
            case 2:
                setsSortBy = "name"
            case 3:
                setsSortBy = "type_.name"
            default:
                ()
            }
        }
        
        if let value = UserDefaults.standard.value(forKey: "setsOrderBy") as? NSNumber {
            switch value {
            case 1:
                setsOrderBy = true
            case 2:
                setsOrderBy = false
            default:
                ()
            }
        }

        values["setsSortBy"] = setsSortBy
        values["setsOrderBy"] = setsOrderBy
        
        return values
    }
}

// MARK: UITableViewDelegate
extension SetsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sets = dataSource!.all()
        let set = sets[indexPath.row]
        performSegue(withIdentifier: "showSet", sender: set)
    }
}
