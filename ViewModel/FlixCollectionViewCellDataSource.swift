//
//  FlixCollectionViewCellDataSource.swift
//  MovieFlix
//
//  Created by Shruti on 26/03/22.
//

import Foundation
import UIKit

class FlixCollectionViewCellDataSource<CELL : UICollectionViewCell,T> : NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
//    private var cellIdentifier : String!
    private var items : [T]!
    var configureCell : (UICollectionViewCell, T, Int) -> () = {_,_,_ in }
    
    
    
    init(items : [T], configureCell : @escaping (UICollectionViewCell, T, Int) -> ()) {
        self.items =  items
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = self.items[indexPath.row]
        if let result = item as? PlayingResults, result.vote_count > 20 {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlixCollectionViewCell", for: indexPath) as! FlixCollectionViewCell
           
            self.configureCell(cell, item, indexPath.row)
           return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlixUnpopularCell", for: indexPath) as! FlixUnpopularCell
           
            self.configureCell(cell, item, indexPath.row)
           return cell
        }
        
    }
    
}
