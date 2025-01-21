//
//  PictureSearchViewController.swift
//  0117_Networks
//
//  Created by 김태형 on 1/17/25.
//

import UIKit
import Alamofire
import SnapKit

//TODO: searchBar.text! 수정

final class PictureSearchViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let sortSwitch = UISwitch()
    private var currentSortType: SortType = .relevant

    private var unsplashData = UnsplashSearch(query: "", page: 1, per_page: 20)
    private var unsplashStatistics = UnsplashStatistics(imageId: "")

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createItemCollectionViewLayout())
    private var selectedButton: UIButton?

    private var pictureSearch: PictureSearch?
    var items: [PictureResult]? {
        didSet {
            guard let items = items, !items.isEmpty else {
                updateNoDataInfoLabelVisibility()
                return
            }
            self.collectionView.reloadData()
            updateNoDataInfoLabelVisibility()
        }
    }
    private var page = 1
    private let noDataInfoLabel = UILabel()
    private var isFetching = false
    private var totalPages: Int = 1 // 초기값을 1로 설정

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureHierarchy(),configureLayout(), configureView(), configureScrollButton(), configureDelegate()].forEach { $0 }
    }
}

// MARK: UI
extension PictureSearchViewController: ViewConfiguration {
    func configureHierarchy() {
        [searchBar, sortSwitch, scrollView, collectionView, noDataInfoLabel].forEach { view.addSubview($0) }
        scrollView.addSubview(stackView)
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        sortSwitch.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(30)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(sortSwitch.snp.bottom)
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
        noDataInfoLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
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

        noDataInfoLabel.text = "사진을 검색해보세요"
        noDataInfoLabel.font = .boldSystemFont(ofSize: 24)
        noDataInfoLabel.textAlignment = .center
        noDataInfoLabel.isHidden = false
        sortSwitch.isOn = false
        sortSwitch.addTarget(self, action: #selector(sortSwitchToggled(_:)), for: .valueChanged)
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

        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureSearchCollectionViewCell.id, for: indexPath) as! PictureSearchCollectionViewCell

        if let items = items, indexPath.item < items.count {
            let picture = items[indexPath.item]
            cell.configureItem(with: picture)
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedPicture = items?[indexPath.item] else { return }
        unsplashStatistics.imageId = selectedPicture.id
        let detailVC = PictureDetailViewController()
        NetworkManager.shared.fetchStatistic(api: unsplashStatistics.toRequest()) { result in
            switch result {
            case .success(let success):
                detailVC.configureDetail(with: success)
                detailVC.configureImage(with: selectedPicture.urls.small)
                self.navigationController?.pushViewController(detailVC, animated: true)
            case .failure(let failure):
                print("error -> ", failure)
            }
        }

    }
}

// MARK: Collection View Prefetching
extension PictureSearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let items = items, !isFetching else { return }
        for indexPath in indexPaths {
            if indexPath.item >= items.count - 3 {
                if page < totalPages {
                    loadMoreData()
                }
                break
            }
        }
    }
}

// MARK: Delegate
extension PictureSearchViewController: DelegateConfiguration {
    func configureDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PictureSearchCollectionViewCell.self, forCellWithReuseIdentifier: PictureSearchCollectionViewCell.id)
        collectionView.prefetchDataSource = self
        searchBar.delegate = self
    }

}

// MARK: SearchBar Delegate
extension PictureSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function, searchBar.text!)
        resetButton()
        resetPage()
        unsplashData = .init(query: searchBar.text!, page: self.page, per_page: 20)

        NetworkManager.shared.fetchItem(api: unsplashData.toRequest()) { result in
            switch result {
            case .success(let value):
                self.pictureSearch = value
                self.totalPages = value.totalPages
                self.items = self.pictureSearch?.results ?? []
            case .failure(let failure):
                print("실패 -> ", failure)
            }
        }

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
        resetPage()
        scrollCollectionView()
        unsplashData = .init(query: searchBar.text!, page: self.page, per_page: 20, color: english)
        NetworkManager.shared.fetchItem(api: unsplashData.toRequest()) { result in
            switch result {
            case .success(let success):
                self.pictureSearch = success
                self.items = self.pictureSearch?.results ?? []
            case .failure(let failure):
                print("error -> ", failure)
            }
        }
    }

    @objc private func sortSwitchToggled(_ sender: UISwitch) {
        currentSortType = sender.isOn ? .latest : .relevant
        performSearch()
        resetPage()
        scrollCollectionView()
    }
}

// MARK: Method
extension PictureSearchViewController {

    // 검색어 입력 시 클릭된 버튼 초기화
    private func resetButton() {
        selectedButton?.backgroundColor = .systemGray5
        selectedButton = nil
    }

    // 페이지 리셋
    private func resetPage() {
        self.page = 1
    }

    private func updateNoDataInfoLabelVisibility() {
        if let items = items, !items.isEmpty {
            noDataInfoLabel.isHidden = true
            collectionView.isHidden = false
        } else {
            noDataInfoLabel.text = (searchBar.text?.isEmpty ?? true) ? "사진을 검색해보세요" : "검색 결과가 없습니다"
            collectionView.isHidden = true
            noDataInfoLabel.isHidden = false
        }
    }

    private func performSearch() {
        guard let query = searchBar.text, !query.isEmpty else { return }
        resetPage()

        unsplashData = .init(query: query, page: self.page, per_page: 20, order_by: currentSortType.rawValue)
        NetworkManager.shared.fetchItem(api: unsplashData.toRequest()) { result in
            switch result {
            case .success(let value):
                self.pictureSearch = value
                self.items = self.pictureSearch?.results ?? []
            case .failure(let error):
                print("error -> ", error)
            }
        }
        print(#function, currentSortType.rawValue)
    }

    private func loadMoreData() {
        print(#function)
        guard let query = searchBar.text, !query.isEmpty else { return }

        isFetching = true
        self.page += 1

        unsplashData = .init(query: query, page: self.page, per_page: 20, order_by: currentSortType.rawValue)
        NetworkManager.shared.fetchItem(api: unsplashData.toRequest()) { result in
            switch result {
            case .success(let success):
                self.items?.append(contentsOf: success.results)
            case .failure(let failure):
                print("error -> ", failure)
            }
            self.isFetching = false
        }

    }

    private func scrollCollectionView() {
        print(#function)
        let hasItems = collectionView.numberOfSections > 0 && collectionView.numberOfItems(inSection: 0) > 0

        guard hasItems else { return }

        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
}
