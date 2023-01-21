//
//  Video.swift
//  MandiriTV
//
//  Created by Maurice Tin on 21/01/23.
//

import Foundation

public struct VideoResponse: Decodable{
    let id: Int
    let results: [VideoResult]
}

public struct Video: Decodable{
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    let id: String
    
    enum CodingKeys: String,CodingKey{
        case name
        case key
        case site
        case size
        case type
        case official
        case publishedAt = "published_at"
        case id
    }
}
