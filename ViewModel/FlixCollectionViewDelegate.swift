//
//  FlixCollectionViewDelegate.swift
//  MovieFlix
//
//  Created by Shruti on 27/03/22.
//

import Foundation
import UIKit

class FlixCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    var selectedSetting: ((Int) -> ())? = .none
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSetting?(indexPath.row)
    }
}
