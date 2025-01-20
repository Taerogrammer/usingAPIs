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
        guard let url = URL(string: item.urls.small) else { return }
        let imageSize: CGSize = imageView.frame.size

        // 비동기 네트워크 요청
        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }

                let renderImage = self.downsampleImage(at: data, to: imageSize, scale: UIScreen.main.scale)

                DispatchQueue.main.async {
                    self.imageView.image = renderImage
                }
            }.resume()
        }

        starButton.setTitle(item.likes.formatted(), for: .normal)
    }

    private func downsampleImage(at imageData: Data, to pointSize: CGSize, scale: CGFloat) -> UIImage {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions)!

        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary

        let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
        return UIImage(cgImage: downsampledImage)
    }
}
