//
//  Helper.swift
//  MovieFlix
//
//  Created by Shruti on 25/03/22.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>.init()

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

extension UIImageView {

    func loadImageWithUrl(_ url: URL) {


        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {

            self.image = imageFromCache
            return
        }

        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                })
                return
            }

            DispatchQueue.main.async(execute: {

                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {

                    self.image = imageToCache

                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
            })
        }).resume()
    }
}

extension UIView
{
    func applyShadowAndRadiusToAllSide(){
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowOpacity = 0.4
            self.layer.shadowRadius = 4.0
            self.layer.masksToBounds = false
            self.clipsToBounds = false
        }
    
}
