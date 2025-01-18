//
//  PhotoDetail.swift
//  0117_Networks
//
//  Created by 김태형 on 1/18/25.
//

import Foundation

struct PhotoDetail: Decodable {
    let id: String
    let downloads: Downloads
    let views: Views
}

struct Downloads: Decodable {
    let total: Int
    let historical: DownloadsHistory
}

struct DownloadsHistory: Decodable {
    let values: [DownloadsValue]
}

struct DownloadsValue: Decodable {
    let date: String
    let value: Int
}

struct Views: Decodable {
    let total: Int
    let historical: ViewsHistory
}

struct ViewsHistory: Decodable {
    let values: [HistoryValue]
}

struct HistoryValue: Decodable {
    let date: String
    let value: Int
}
