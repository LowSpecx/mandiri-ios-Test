//
//  Genre.swift
//  MandiriTV
//
//  Created by Maurice Tin on 18/01/23.
//

import Foundation

struct GenreResponse: Decodable{
    let genres: [Genre]
}

struct Genre: Decodable{
    let id: Int
    let name: String
}


