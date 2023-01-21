//
//  Author.swift
//  MandiriTV
//
//  Created by Maurice Tin on 21/01/23.
//

import Foundation

struct Author: Decodable{
    let name: String
    let username: String
    let avatarPath: String?
    let rating: Double?
    
    enum CodingKeys: String,CodingKey{
        case name
        case username
        case avatarPath = "avatar_path"
        case rating
    }
}
