//
//  PictureDetailViewController.swift
//  0117_Networks
//
//  Created by 김태형 on 1/17/25.
//

import UIKit
import Kingfisher
import SnapKit

final class PictureDetailViewController: UIViewController {


    private let imageView = UIImageView()
    private let likesLabel = UILabel()
    private let downloadsLabel = UILabel()
    private let viewsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureHierarchy(), configureLayout(), configureView()].forEach { $0 }
    }
}

// MARK: UI
extension PictureDetailViewController: ViewConfiguration {
    func configureHierarchy() {
        [imageView, likesLabel, downloadsLabel, viewsLabel].forEach { view.addSubview($0) }
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }

        likesLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        downloadsLabel.snp.makeConstraints { make in
            make.top.equalTo(likesLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        viewsLabel.snp.makeConstraints { make in
            make.top.equalTo(downloadsLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureView() {
        imageView.backgroundColor = .red
    }

    func configureItem(with item: PictureResult, detail: PhotoDetail) {
        let imageURL = URL(string: item.urls.full)
        imageView.kf.setImage(with: imageURL)

        likesLabel.text = "좋아요 \(item.likes)"
        downloadsLabel.text = "다운로드 \(detail.downloads.total)"
        viewsLabel.text = "조회 수 \(detail.views.total)"
    }
}
