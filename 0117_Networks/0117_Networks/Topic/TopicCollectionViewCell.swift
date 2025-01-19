//
//  TopicCollectionViewCell.swift
//  0117_Networks
//
//  Created by 김태형 on 1/19/25.
//

import UIKit
import Kingfisher
import SnapKit

final class TopicCollectionViewCell: UICollectionViewCell {
    static let id = "TopicCollectionViewCell"

    let imageView = UIImageView()
    let starButton = UIButton()

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
        [imageView, starButton].forEach { contentView.addSubview($0) }
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        starButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(imageView).inset(12)
        }
    }
    
    func configureView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray2
        imageView.layer.cornerRadius = 8

        starButton.setTitle("", for: .normal)
        starButton.titleLabel?.font = .systemFont(ofSize: 12)
        starButton.setImage(UIImage(systemName: "star.fill"), for: .disabled)
        starButton.tintColor = .yellow
        starButton.clipsToBounds = true
        starButton.layer.cornerRadius = 14
        starButton.backgroundColor = .gray
        starButton.contentEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
        starButton.isEnabled = false
    }

    func configureItem(with item: Topic) {
        let url = URL(string: item.urls.raw)
        imageView.kf.setImage(with: url)
        starButton.setTitle(item.likes.formatted(), for: .normal)
    }
}
