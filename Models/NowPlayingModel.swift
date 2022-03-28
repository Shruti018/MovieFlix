//
//  LoginUserModel.swift
//  MovieFlix
//
//  Created by Shruti on 25/03/22.
//

import Foundation

// MARK: - NowPlayingModel
struct NowPlayingModel: Codable
{
    let id: Int?
    var results: [PlayingResults]
}

// MARK: - Result
struct PlayingResults: Codable {
    let poster_path: String
    let backdrop_path: String
    let original_title: String
    let overview: String
    let vote_count: Int
//    let site: String?
//    let size: String?
//    let type: String?
//    let official: String?
//    let published_at: String?
//    let id: String?

    enum CodingKeys: String, CodingKey {
        case poster_path = "poster_path"
        case backdrop_path = "backdrop_path"
        case original_title = "original_title"
        case overview = "overview"
        case vote_count
//        case site = "site"
//        case size = "size"
//        case type = "type"
//        case official = "official"
//        case published_at = "published_at"
//        case id = "id"
    }
}
