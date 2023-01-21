//
//  Review.swift
//  MandiriTV
//
//  Created by Maurice Tin on 21/01/23.
//

import Foundation

struct ReviewResponse: Decodable{
    let id: Int
    let page: Int
    let results: [Review]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String,CodingKey{
        case id
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Review: Decodable{
    public let author: String
    public let authorDetails: Author
    public let content: String
    public let createdAt: String
    public let id: String
    public let updatedAt: String
    public let url: String
    
    enum CodingKeys: String,CodingKey{
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}
