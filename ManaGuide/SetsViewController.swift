//
//  SetsViewController.swift
//  ManaGuide
//
//  Created by Jovito Royeca on 21/07/2017.
//  Copyright © 2017 Jovito Royeca. All rights reserved.
//

import UIKit
import ManaKit
import DATASource

class SetsViewController: BaseViewController {

    // MARK: Variables
    var dataSource: DATASource?

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: actions
    @IBAction func rightMenuAction(_ sender: UIBarButtonItem) {
        showRightMenu()
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = getDataSource(nil)
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

}

// MARK: UITableViewDelegate
extension SetsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sets = dataSource!.all()
        let set = sets[indexPath.row]
        performSegue(withIdentifier: "showSet", sender: set)
    }
}
