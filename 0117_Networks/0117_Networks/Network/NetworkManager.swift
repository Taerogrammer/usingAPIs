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

    // 정보 불러오기 test
    func fetchItem(api: UnsplashRequest, completionHandler: @escaping (Result<PictureSearch, Error>) -> Void) {
        AF.request(
            api.endPoint,
            method: api.method,
            parameters: api.parameter,
            encoding: URLEncoding(destination: .queryString))
        .validate(statusCode: 200..<500)
        .responseDecodable(of: PictureSearch.self) { response in
            completionHandler(response.result.mapError { $0 as Error })
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

    func fetchTopic(api: UnsplashRequest, completionHandler: @escaping (Result<[Topic], Error>) -> Void) {
        AF.request(
            api.endPoint,
            method: api.method,
            parameters: api.parameter,
            encoding: URLEncoding(destination: .queryString))
        .validate(statusCode: 200..<500)
        .responseDecodable(of: [Topic].self) { response in
            completionHandler(response.result.mapError { $0 as Error })
        }
    }
}
