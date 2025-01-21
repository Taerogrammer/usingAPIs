//
//  String+Extension.swift
//  0117_Networks
//
//  Created by 김태형 on 1/21/25.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
}
