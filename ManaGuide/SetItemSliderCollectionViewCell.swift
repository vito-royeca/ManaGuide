//
//  SetItemSliderCollectionViewCell.swift
//  ManaGuide
//
//  Created by Jovito Royeca on 21/07/2017.
//  Copyright © 2017 Jovito Royeca. All rights reserved.
//

import UIKit

class SetItemSliderCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        titleLabel.adjustsFontSizeToFitWidth = true
    }

}
