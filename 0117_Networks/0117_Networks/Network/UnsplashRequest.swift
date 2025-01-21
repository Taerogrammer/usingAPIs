//
//  UnsplashRequest.swift
//  0117_Networks
//
//  Created by 김태형 on 1/21/25.
//

import Foundation
import Alamofire

enum SortType: String {
    case relevant = "relevant" // 관련순 (기본값)
    case latest = "latest"     // 최신순
}

// 이렇게 넣어놓고 변수에 넣어서 관리
enum UnsplashRequest {
    case topic(topicID: String, page: Int)
    case search(query: String, page: Int, per_page: Int, order_by: String = "relevant", color: String? = nil)
    case statistics(imageId: String)

    var baseUrl: String { return "https://api.unsplash.com" }
    var endPoint: URL {
        switch self {
        case .topic(let topicID, _):
            return URL(string: baseUrl + "/topics/\(topicID)/photos")!
        case .search(_, _, _, _, _):
            return URL(string: baseUrl + "/search/photos")!
        case .statistics(let imageId):
            return URL(string: baseUrl + "/photos/\(imageId)/statistics")!
        }
    }

    var parameter: Parameters {
        switch self {
        case .topic(_, let page):
            return ["page": page, "client_id": APIKey.unsplash.rawValue]
        case .search(let query, let page, let per_page, let order_by, let color):
            var params: Parameters = ["query": query, "page": page, "per_page": per_page, "order_by": order_by, "client_id": APIKey.unsplash.rawValue]
            guard let color = color else { return params }
            params["color"] = color

            return params
        case .statistics(_):
            return ["client_id": APIKey.unsplash.rawValue]
        }
    }

    // 현재 코드는 모두 .get
    var method: HTTPMethod {
        return .get
    }
}
