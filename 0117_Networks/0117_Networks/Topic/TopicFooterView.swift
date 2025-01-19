//
//  TopicFooterView.swift
//  0117_Networks
//
//  Created by 김태형 on 1/19/25.
//

import UIKit

final class TopicFooterView: UICollectionReusableView {
    static let id = "TopicFooterView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
