//
//  DetailVC.swift
//  MovieFlix
//
//  Created by Shruti on 27/03/22.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var imgPoster: UIImageView!
    
    var data: PlayingResults!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpData()
    }
    
    func setUpData() {
        let posterString = "w342\(data.poster_path)"
        if let strUrl = "\(IMG_URL)\(posterString)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
              let imgUrl = URL(string: strUrl) {
            self.imgPoster.loadImageWithUrl(imgUrl)
        }
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
