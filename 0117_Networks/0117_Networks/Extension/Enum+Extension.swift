//
//  Enum+Extension.swift
//  0117_Networks
//
//  Created by 김태형 on 1/17/25.
//

import Foundation

/// 버튼 색상을 기준으로 영어 문자열로 반환
enum ColorOption: String {
    case 블랙
    case 화이트
    case 옐로우
    case 레드
    case 퍼플
    case 그린
    case 블루

    var englishColor: String {
        switch self {
        case .블랙: return "black"
        case .화이트: return "white"
        case .옐로우: return "yellow"
        case .레드: return "red"
        case .퍼플: return "purple"
        case .그린: return "green"
        case .블루: return "blue"
        }
    }
}

/// API 리스트
enum SplashAPI: String {
    case topic = "https://api.unsplash.com/topics/"
    case search = "https://api.unsplash.com/search/photos?"
    case detail = "https://api.unsplash.com/photos/"
}
