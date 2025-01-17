//
//  NetworkManager.swift
//  0117_Networks
//
//  Created by 김태형 on 1/17/25.
//

import UIKit
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    static let display = 20
    
    // 정보 불러오기
    func fetchItem(query: String, page: Int, orderBy: String = "relevant", completion: @escaping (Result<PictureSearch, Error>) -> Void) {
        let url = "\(SplashAPI.search.rawValue)&query=\(query)&page=\(page)&order_by=\(orderBy)&client_id=\(APIKey.unsplash.rawValue)"
        
        print(#function, url)
        
        AF.request(url, method: .get)
            .responseDecodable(of: PictureSearch.self) { response in
                completion(response.result.mapError { $0 as Error })
            }
    }
    
}
