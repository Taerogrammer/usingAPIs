//
//  DTO.swift
//  0117_Networks
//
//  Created by 김태형 on 1/21/25.
//

import Foundation

struct UnsplashSearch {
    var query: String
    var page: Int
    var per_page: Int
    var order_by: String = "relevant"
    var color: String?

    func toRequest() -> UnsplashRequest {
        return .search(query: query, page: page, per_page: per_page, order_by: order_by, color: color)
    }
}
