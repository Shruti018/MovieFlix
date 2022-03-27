//
//  FlixViewModel.swift
//  MovieFlix
//
//  Created by Shruti on 26/03/22.
//

import Foundation

class FlixViewModel : NSObject {
    
    private var apiService : APIParse!
    private(set) var nowPlayingData : NowPlayingModel! {
        didSet {
            self.bindFlixViewModelToController()
        }
    }
    
    var bindFlixViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService = APIParse()
        callFuncToGetNowPlayingData()
    }
    
    func callFuncToGetNowPlayingData() {
        self.apiService.apiNowPlaying { (data) in
            self.nowPlayingData = data
        }
    }
}
