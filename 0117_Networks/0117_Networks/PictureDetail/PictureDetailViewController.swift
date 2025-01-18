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

    private let scrollView = UIScrollView()
    private let contentView = UIView()

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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [imageView, likesLabel, downloadsLabel, viewsLabel].forEach { contentView.addSubview($0) }
    }
    
    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.width.equalTo(contentView)
        }
        likesLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.bottom.equalTo(contentView).inset(20)
        }

    }
    
    func configureView() {
        scrollView.backgroundColor = .blue
        contentView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
    }

    func configureItem(with item: PictureResult, detail: PhotoDetail) {
        let imageURL = URL(string: item.urls.small)
        imageView.kf.setImage(with: imageURL)

        likesLabel.text = "좋아요 \(item.likes)"
        downloadsLabel.text = "다운로드 \(detail.downloads.total)"
        viewsLabel.text = "조회 수 \(detail.views.total)"
    }
}
