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
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createItemCollectionViewLayout())
    private var selectedButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureHierarchy(),configureLayout(), configureView(), configureScrollButton(), configureDelegate()].forEach { $0 }
    }
}

// MARK: UI
extension PictureSearchViewController: ViewCofiguration {
    func configureHierarchy() {
        [searchBar, scrollView, collectionView].forEach { view.addSubview($0) }
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
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.bottom.horizontalEdges.equalToSuperview()
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
        button.addTarget(self, action: #selector(scrollButtonTapped(_:)), for: .touchUpInside)

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

    private func createItemCollectionViewLayout() -> UICollectionViewFlowLayout {
        let sectionInsets: CGFloat = 4
        let cellSpacing: CGFloat = 2
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth - (sectionInsets * 4) - cellSpacing

        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 1.5)
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInsets, bottom: 0, right: sectionInsets)

        return layout
    }
}

// MARK: collectionView
extension PictureSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function, dummyData.results.count)
        return dummyData.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureSearchCollectionViewCell.id, for: indexPath) as! PictureSearchCollectionViewCell

        return cell
    }
}

// MARK: Delegate
extension PictureSearchViewController: DelegateConfiguration {
    func configureDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PictureSearchCollectionViewCell.self, forCellWithReuseIdentifier: PictureSearchCollectionViewCell.id)
        searchBar.delegate = self
    }

}

// MARK: SearchBar Delegate
extension PictureSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function, searchBar.text)
        resetButton()
        view.endEditing(true)
    }
}

// MARK: @objc
extension PictureSearchViewController {

    @objc private func scrollButtonTapped(_ sender: UIButton) {
        if selectedButton == sender { return }
        selectedButton?.backgroundColor = .systemGray5
        sender.backgroundColor = .gray
        selectedButton = sender

        guard let koreanTitle = sender.currentTitle,
              let colorOption = ColorOption(rawValue: koreanTitle) else { return }

        let english = colorOption.englishColor
        print("english ", english)
    }
}

// MARK: Method
extension PictureSearchViewController {

    // 검색어 입력 시 클릭된 버튼 초기화
    private func resetButton() {
        selectedButton?.backgroundColor = .systemGray5
        selectedButton = nil
    }
}
