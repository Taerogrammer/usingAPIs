//
//  PhotoSearch.swift
//  0117_Networks
//
//  Created by 김태형 on 1/17/25.
//

import Foundation

struct PictureSearch: Decodable {
    let totalPages: Int
    let results: [PictureResult]

    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case results
    }
}

struct PictureResult: Decodable {
    let id: String
    let urls: PictureURL
    let likes: Int
    let likedByUser: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case urls
        case likes
        case likedByUser = "liked_by_user"
    }
}

struct PictureURL: Decodable {
    let raw: String
    let small: String
}
