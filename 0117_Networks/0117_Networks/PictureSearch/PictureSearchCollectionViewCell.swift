//
//  PictureSearchCollectionViewCell.swift
//  0117_Networks
//
//  Created by 김태형 on 1/17/25.
//

import UIKit
import SnapKit
import Kingfisher

final class PictureSearchCollectionViewCell: UICollectionViewCell {
    static let id = "PictureSearchCollectionViewCell"
    let imgView = UIImageView()
    let starButton = UIButton()
    let likeImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [configureHierarchy(), configureLayout(), configureView()].forEach { $0 }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PictureSearchCollectionViewCell: ViewConfiguration {
    func configureHierarchy() {
        [imgView, starButton, likeImageView].forEach { addSubview($0) }
    }
    
    func configureLayout() {
        imgView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        starButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(imgView).inset(12)
        }
        likeImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(imgView).inset(12)
            make.width.height.equalTo(44)
        }
    }
    
    func configureView() {
        imgView.backgroundColor = .red
        imgView.contentMode = .scaleToFill
        starButton.setTitle("", for: .normal)
        starButton.titleLabel?.font = .systemFont(ofSize: 12)
        starButton.setImage(UIImage(systemName: "star.fill"), for: .disabled)
        starButton.tintColor = .yellow
        starButton.clipsToBounds = true
        starButton.layer.cornerRadius = 12
        starButton.backgroundColor = .gray
        starButton.contentEdgeInsets = .init(top: 8, left: 14, bottom: 8, right: 14)
        starButton.isEnabled = false

        likeImageView.image = UIImage(systemName: "heart.circle")
        likeImageView.clipsToBounds = true
        likeImageView.layer.cornerRadius = 22
        likeImageView.tintColor = .white
    }
    func configureItem(with row: PictureResult) {
        guard let url = URL(string: row.urls.raw) else { return }
        let imageSize: CGSize = imgView.frame.size

        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                let renderImage = self.downsampleImage(at: data, to: imageSize, scale: UIScreen.main.scale)

                DispatchQueue.main.async {
                    self.imgView.image = renderImage
                }
            }.resume()
        }
        starButton.setTitle(row.likes.formatted(), for: .normal)
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
