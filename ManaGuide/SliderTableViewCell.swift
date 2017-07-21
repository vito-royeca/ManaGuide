//
//  SliderTableViewCell.swift
//  ManaGuide
//
//  Created by Jovito Royeca on 21/07/2017.
//  Copyright © 2017 Jovito Royeca. All rights reserved.
//

import UIKit

let kSliderTableViewCellHeight = CGFloat(140)
let kSliderTableViewCellContentHeight = CGFloat(111)

@objc protocol SliderTableViewCellDelegate : NSObjectProtocol {
    func showAll()
    func showItem(item: AnyObject)
    func configureCell(cell: UICollectionViewCell, withItem item: AnyObject)
}

class SliderTableViewCell: UITableViewCell {

    // MARK: Variables
    var items:[AnyObject]?
    var delegate:SliderTableViewCellDelegate?
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Actions
    @IBAction func showAllAction(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.showAll()
        }
    }
    
    
    // MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: "SetItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SetCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: UICollectionViewDataSource
extension SliderTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        
        if let items = items {
            count = items.count
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetCell", for: indexPath)
        
        if let items = items,
            let delegate = delegate {
            
            let item = items[indexPath.row]
            delegate.configureCell(cell: cell, withItem: item)
        }
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension SliderTableViewCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let items = items,
            let delegate = delegate {
            
            let item = items[indexPath.row]
            delegate.showItem(item: item)
        }
    }
}
