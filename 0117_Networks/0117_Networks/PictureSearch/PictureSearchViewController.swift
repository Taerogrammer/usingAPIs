//
//  PictureSearchViewController.swift
//  0117_Networks
//
//  Created by 김태형 on 1/17/25.
//

import UIKit
import Alamofire
import SnapKit

final class PictureSearchViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
//    private let collectionView = UICollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureHierarchy(),configureLayout(), configureView(), configureScrollButton()].forEach { $0 }
    }
}

// MARK: UI
extension PictureSearchViewController: ViewCofiguration {
    func configureHierarchy() {
        [searchBar, scrollView].forEach { view.addSubview($0) }
        scrollView.addSubview(stackView)
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.height.equalTo(44)
        }
    }
    
    func configureView() {
        navigationItem.title = "SEARCH PHOTO"
        searchBar.placeholder = "키워드 검색"
        scrollView.showsHorizontalScrollIndicator = false

        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    private func ScrollButton(title: String, tintColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        button.tintColor = tintColor
        button.contentEdgeInsets = .init(top: 2, left: 6, bottom: 2, right: 12)
        button.invalidateIntrinsicContentSize()
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGray5

        return button
    }
    private func configureScrollButton() {
        let blackButton = ScrollButton(title: "블랙", tintColor: .black)
        let whiteButton = ScrollButton(title: "화이트", tintColor: .white)
        let yellowButton = ScrollButton(title: "옐로우", tintColor: .yellow)
        let redButton = ScrollButton(title: "레드", tintColor: .red)
        let purpleButton = ScrollButton(title: "퍼플", tintColor: .purple)
        let greenButton = ScrollButton(title: "그린", tintColor: .green)
        let blueButton = ScrollButton(title: "블루", tintColor: .blue)
        [blackButton, whiteButton, yellowButton, redButton, purpleButton, greenButton, blueButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }
}
