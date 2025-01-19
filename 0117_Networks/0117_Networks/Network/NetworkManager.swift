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
    
    // 색상을 기준으로 정보 불러오기
    func fetchColorItem(query: String, page: Int, orderBy: String = "relevant", color: String, completion: @escaping (Result<PictureSearch, Error>) -> Void) {
        let url = "\(SplashAPI.search.rawValue)&query=\(query)&page=\(page)&order_by=\(orderBy)&color=\(color)&client_id=\(APIKey.unsplash.rawValue)"
        print(#function, url)
        AF.request(url, method: .get)
            .responseDecodable(of: PictureSearch.self) { response in
                completion(response.result.mapError { $0 as Error })
            }
    }
    
    // detail
    func fetchPhotoDetail(photoId: String, completion: @escaping (Result<PhotoDetail, Error>) -> Void) {
        let url = "https://api.unsplash.com/photos/\(photoId)/statistics?client_id=\(APIKey.unsplash.rawValue)"
        print(#function, url)
        
        AF.request(url, method: .get)
            .responseDecodable(of: PhotoDetail.self) { response in
                completion(response.result.mapError { $0 as Error })
            }
    }
    
    // topic
    func fetchTopic(topic: String, completion: @escaping (Result<[Topic], Error>) -> Void) {
        let url = "https://api.unsplash.com/topics/\(topic)/photos?&page=1&client_id=\(APIKey.unsplash.rawValue)"
        AF.request(url, method: .get)
            .responseDecodable(of: [Topic].self) { response in
                completion(response.result.mapError { $0 as Error })
            }
        
    }
    
}
