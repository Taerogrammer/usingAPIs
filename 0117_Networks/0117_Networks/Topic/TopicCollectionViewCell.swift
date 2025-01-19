//
//  TopicCollectionViewCell.swift
//  0117_Networks
//
//  Created by 김태형 on 1/19/25.
//

import UIKit
import SnapKit

final class TopicCollectionViewCell: UICollectionViewCell {
    static let id = "TopicCollectionViewCell"

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [configureHierarchy(), configureLayout(), configureView()].forEach { $0 }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI
extension TopicCollectionViewCell: ViewConfiguration {
    func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blue
    }
}
