//
//  FlixCollectionViewCell.swift
//  MovieFlix
//
//  Created by Shruti on 27/03/22.
//

import UIKit

class FlixCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnDelete.applyShadowAndRadiusToAllSide()
    }

}
