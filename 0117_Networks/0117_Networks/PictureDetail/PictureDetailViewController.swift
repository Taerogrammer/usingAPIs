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
    private let infoLabel = UILabel()
    private let downloadsLabel = UILabel()
    private let downloadsText = UILabel()
    private let viewsLabel = UILabel()
    private let viewsText = UILabel()

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
        [imageView, infoLabel, downloadsLabel, downloadsText, viewsLabel, viewsText].forEach { contentView.addSubview($0) }
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
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.equalTo(contentView).inset(20)
        }
        viewsLabel.snp.makeConstraints { make in
            make.leading.equalTo(infoLabel.snp.trailing).offset(44)
            make.centerY.equalTo(infoLabel)
        }
        viewsText.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(viewsLabel)
        }
        downloadsLabel.snp.makeConstraints { make in
            make.leading.equalTo(viewsLabel)
            make.top.equalTo(viewsLabel.snp.bottom).offset(24)
            make.bottom.equalTo(contentView).inset(20)
        }
        downloadsText.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(downloadsLabel)
        }
    }
    
    func configureView() {
//        scrollView.backgroundColor = .blue
//        contentView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        infoLabel.text = "정보"
        infoLabel.font = .boldSystemFont(ofSize: 24)
        viewsLabel.text = "조회수"
        viewsLabel.font = .boldSystemFont(ofSize: 14)
        viewsText.font = .systemFont(ofSize: 14)
        downloadsLabel.text = "다운로드"
        downloadsLabel.font = .boldSystemFont(ofSize: 14)
        downloadsText.font = .systemFont(ofSize: 14)
    }

    func configureItem(with item: PictureResult, detail: PhotoDetail) {
        let imageURL = URL(string: item.urls.small)
        imageView.kf.setImage(with: imageURL)
        downloadsText.text = "\(detail.downloads.total.formatted())"
        viewsText.text = "\(detail.views.total.formatted())"
    }
}
