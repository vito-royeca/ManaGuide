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
            request!.predicate = NSPredicate(format: "set.code = %@", set!.code!)
            // TODO: get key and ascending from UserDefaults
            request!.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
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
            var key = "name"
            var ascending = false
            
            if let value = userInfo["setSortBy"] as? NSNumber {
                switch value {
                case 1:
                    key = "name"
                case 2:
                    key = "mciNumber"
                default:
                    ()
                }
            }
            
            if let value = userInfo["setOrderBy"] as? NSNumber {
                switch value {
                case 1:
                    ascending = true
                case 2:
                    ascending = false
                default:
                    ()
                }
            }
            
            // TODO: fi if there's no key or ascending
            // TODO: handle setDisplayBy
            // TODO: handle setShow
            
            let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CMCard")
            request.predicate = NSPredicate(format: "set.code = %@", set!.code!)
            request.sortDescriptors = [NSSortDescriptor(key: key, ascending: ascending ? true : false)]

            dataSource = getDataSource(request)
            tableView.reloadData()
        }
    }

}

// MARK: UITableViewDelegate
extension SetViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCardTableViewCellHeight
    }
}
