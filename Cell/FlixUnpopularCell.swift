//
//  FlixUnpopularCell.swift
//  MovieFlix
//
//  Created by Shruti on 27/03/22.
//

import UIKit

class FlixUnpopularCell: UICollectionViewCell {

    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnDelete.applyShadowAndRadiusToAllSide()
    }

}
