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
    let historical: HistoryList
}

struct Views: Decodable {
    let total: Int
    let historical: HistoryList
}

struct HistoryList: Decodable {
    let values: [HistoryValue]
}

struct DownloadsHistory: Decodable {
    let values: [HistoryValue]
}

struct HistoryValue: Decodable {
    let date: String
    let value: Int
}
