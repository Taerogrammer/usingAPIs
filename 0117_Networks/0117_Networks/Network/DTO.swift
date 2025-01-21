//
//  DTO.swift
//  0117_Networks
//
//  Created by 김태형 on 1/21/25.
//

import Foundation

/*
 구조체와 enum은 같은 값 타입이지만 enum을 통해 데이터를 관리할 수 없습니다.
 1. enum은 불변 타입이기 때문에 기존 인스턴스의 데이터를 변경할 수 없습니다.
 2. enum은 저장 프로퍼티를 가지지 못하기 때문에 항상 새로운 인스턴스를 만들어야 합니다.
 */
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

struct UnsplashTopic {
    var topicID: String
    var page: Int

    func toRequest() -> UnsplashRequest {
        return .topic(topicID: topicID, page: page)
    }
}
