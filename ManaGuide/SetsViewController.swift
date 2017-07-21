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
            // TODO: get key and ascending from UserDefaults
            request!.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
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
            var key = "releaseDate"
            var ascending = false
            
            if let value = userInfo["setsSortBy"] as? NSNumber {
                switch value {
                case 1:
                    key = "releaseDate"
                case 2:
                    key = "name"
                case 3:
                    key = "type_.name"
                default:
                    ()
                }
            }
            
            if let value = userInfo["setsOrderBy"] as? NSNumber {
                switch value {
                case 1:
                    ascending = true
                case 2:
                    ascending = false
                default:
                    ()
                }
            }
            
            let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CMSet")
            request.sortDescriptors = [NSSortDescriptor(key: key, ascending: ascending ? true : false)]
            
            dataSource = getDataSource(request)
            tableView.reloadData()
        }
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
