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

    /* Generic 구현을 통해 일반화함
    // search
    func fetchItemWithNoGeneric(api: UnsplashRequest, completionHandler: @escaping (Result<PictureSearch, Error>) -> Void) {
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

    // statistics
    func fetchStatistic(api: UnsplashRequest, completionHandler: @escaping (Result<PhotoDetail, Error>) -> Void) {
        AF.request(
            api.endPoint,
            method: api.method,
            parameters: api.parameter,
            encoding: URLEncoding(destination: .queryString))
        .validate(statusCode: 200..<500)
        .responseDecodable(of: PhotoDetail.self) { response in
            completionHandler(response.result.mapError { $0 as Error })
        }
    }

     // topic
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
     */

    // Generic 사용
    func fetchItem<T: Decodable>(api: UnsplashRequest,
                                 type: T.Type,
                                 completionHandler: @escaping (Result<T, Error>) -> Void) {
        AF.request(
            api.endPoint,
            method: api.method,
            parameters: api.parameter,
            encoding: URLEncoding(destination: .queryString))
            .cURLDescription { print($0) }
            .validate(statusCode: 200..<500)
            .responseDecodable(of: T.self) { response in
            completionHandler(response.result.mapError { $0 as Error })
        }
    }
}
