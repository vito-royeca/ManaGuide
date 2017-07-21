//
//  FeaturedViewController.swift
//  ManaGuide
//
//  Created by Jovito Royeca on 20/07/2017.
//  Copyright © 2017 Jovito Royeca. All rights reserved.
//

import UIKit
import DATASource
import ManaKit

class FeaturedViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: "SetCell")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSet" {
            if let dest = segue.destination as? SetViewController,
                let set = sender as? CMSet {
                
                dest.title = set.name
                dest.set = set
            }
        } else if segue.identifier == "showSets" {
            if let dest = segue.destination as? SetsViewController {
                dest.title = "Sets"
            }
        }
    }

    // MARK: Custom methods
    func latestSets() -> [CMSet]? {
        var sets:[CMSet]?
        
        do {
            let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CMSet")
            request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
            request.fetchLimit = 8

            if let result = try ManaKit.sharedInstance.dataStack!.mainContext.fetch(request) as? [CMSet] {
                sets = result
            }
        } catch {}
        
        return sets
    }
}

// MARK: UITableViewDataSource
extension FeaturedViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = 1
        
        return rows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        switch indexPath.row {
        case 0:
            if let c = tableView.dequeueReusableCell(withIdentifier: "SetCell") as? SliderTableViewCell {
                c.titleLabel.text = "Latest Sets"
                c.delegate = self
                c.items = latestSets()
                c.flowLayout.itemSize = CGSize(width: (c.collectionView.frame.size.width / 3) - 20, height: kSliderTableViewCellContentHeight - 5)
                c.flowLayout.scrollDirection = .horizontal
                c.flowLayout.minimumInteritemSpacing = CGFloat(5)
                c.collectionView.reloadData()
                cell = c
            }
        default:
            ()
        }
        
        return cell!
    }
}

// MARK: UITableViewDelegate
extension FeaturedViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat(0)
        
        switch indexPath.row {
        case 0:
            height = kSliderTableViewCellHeight
        default:
            height = UITableViewAutomaticDimension
        }
        
        return height
    }
}

// MARK: SliderTableViewCellDelegate
extension FeaturedViewController : SliderTableViewCellDelegate {
    func showAll() {
        performSegue(withIdentifier: "showSets", sender: nil)
    }
    
    func showItem(item: AnyObject) {
        if let set = item as? CMSet {
            performSegue(withIdentifier: "showSet", sender: set)
        }
    }
    
    func configureCell(cell: UICollectionViewCell, withItem item: AnyObject) {
        if let cell = cell as? SetItemSliderCollectionViewCell,
            let item = item as? CMSet {
            
            if let rarity = ManaKit.sharedInstance.findOrCreateObject("CMRarity", objectFinder: ["name": "Common" as AnyObject]) as? CMRarity {
                cell.iconView.image = ManaKit.sharedInstance.setImage(set: item, rarity: rarity)
                cell.titleLabel.text = item.name
            }
        }
    }
}
