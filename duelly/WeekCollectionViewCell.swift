//
//  WeekCollectionViewCell.swift
//  duelly
//
//  Created by Mike Hu on 6/21/16.
//  Copyright © 2016 hi_hu. All rights reserved.
//

import UIKit

class WeekCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weekTokenView: UIView!
    @IBOutlet weak var weekButton: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        weekTokenView.layer.cornerRadius = 20
    }
}
