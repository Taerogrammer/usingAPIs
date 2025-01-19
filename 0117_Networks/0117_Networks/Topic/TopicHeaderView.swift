//
//  TopicHeaderView.swift
//  0117_Networks
//
//  Created by 김태형 on 1/19/25.
//

import UIKit
import SnapKit

final class TopicHeaderView: UICollectionReusableView {
    static let id = "TopicHeaderView"

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [configureHierarchy(), configureLayout(), configureView()].forEach{ $0 }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopicHeaderView: ViewConfiguration {
    func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureView() {
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
    }
    func configureHeaderTitle(title: String) {
        titleLabel.text = title
    }
}
