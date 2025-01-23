//
//  TopicViewController.swift
//  0117_Networks
//
//  Created by 김태형 on 1/17/25.
//

import UIKit
import SnapKit

final class TopicViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
    private var topics: [String] = ["골든 아워", "비즈니스 및 업무", "건축 및 인테리어"] {
        didSet {
            if topics.count == 3 { fetchTopics() }
        }
    }
    private var unsplashTopicData = UnsplashTopic(topicID: "", page: 1)
    private var unsplashStatistics = UnsplashStatistics(imageId: "")

    private let topicsTest: [String] = ["건축 및 인테리어", "골든 아워", "배경 화면", "자연", "3D 렌더링", "여행하다", "텍스쳐 및 패턴", "거리 사진", "필름", "기록의", "실험적인", "동물", "패션 및 뷰티", "사람", "비즈니스 및 업무", "식음료"]

    // 딕셔너리를 이용한 변환
    private let topicEnglish: [String: String] = [
        "건축 및 인테리어": "architecture-interior",
        "골든 아워": "golden-hour",
        "배경 화면": "wallpapers",
        "자연": "nature",
        "3D 렌더링": "3d-renders",
        "여행하다": "travel",
        "텍스쳐 및 패턴": "textures-patterns",
        "거리 사진": "street-photography",
        "필름": "film",
        "기록의": "archival",
        "실험적인": "experimental",
        "동물": "animals",
        "패션 및 뷰티": "fashion-beauty",
        "사람": "people",
        "비즈니스 및 업무": "business-work",
        "식음료": "food-drink"
    ]

    private var topicImages: [[Topic]] = Array(repeating: [], count: 3)

    private var timer = Timer.self
    private var oneMinutePassed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureHierarchy(), configureLayout(), configureView(), configureDelegate(), fetchTopics(), configureRefreshControl()].forEach { $0 }
        view.backgroundColor = .defaultBackgroundColor
    }
}

// MARK: UI
extension TopicViewController: ViewConfiguration {
    func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(collectionView)
    }
    
    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(scrollView.snp.height)
        }
    }
    
    func configureView() {
        navigationItem.title = "TOPIC"
        scrollView.showsVerticalScrollIndicator = false
    }

    private func configureRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(section: createSectionLayout())
    }

    private func createSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let itemInset: CGFloat = 4
        item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(160), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(20))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)

        section.boundarySupplementaryItems = [header, footer]
        return section
    }


}

// MARK: Delegate
extension TopicViewController: DelegateConfiguration {
    func configureDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.id)
        collectionView.register(TopicHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TopicHeaderView.id)
        collectionView.register(TopicFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: TopicFooterView.id)
    }
}

// MARK: Collection View
extension TopicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return topics.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topicImages[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.id, for: indexPath) as! TopicCollectionViewCell
        let topicDetail = topicImages[indexPath.section][indexPath.item]
        cell.configureItem(with: topicDetail)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = PictureDetailViewController()
        unsplashStatistics.imageId = topicImages[indexPath.section][indexPath.item].id
        NetworkManager.shared.fetchItem(api: unsplashStatistics.toRequest(),
                                        type: PhotoDetail.self) { result in
            switch result {
            case .success(let success):
                detailVC.configureImage(with: self.topicImages[indexPath.section][indexPath.item].urls.small)
                detailVC.configureDetail(with: success)
                self.navigationController?.pushViewController(detailVC, animated: true)
            case .failure(let failure):
                print("error -> ", failure)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TopicHeaderView.id, for: indexPath) as! TopicHeaderView
            header.configureHeaderTitle(title: topics[indexPath.section])

            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TopicFooterView.id, for: indexPath) as! TopicFooterView

            return footer
        }
    }
}


// MARK: Methods
extension TopicViewController {

    private func fetchTopics() {
        // DispatchGroup으로 묶어 Task 그룹화
        let dispatchGroup = DispatchGroup()
        for (index, topic) in topics.enumerated() {
            guard let convertedTopic = topicEnglish[topic] else { return }
            // 그룹화 Task 시작
            unsplashTopicData = .init(topicID: convertedTopic, page: 1)

            dispatchGroup.enter()
            NetworkManager.shared.fetchItem(api: unsplashTopicData.toRequest(),
                                            type: [Topic].self) { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let success):
                    self.topicImages[index] = success
                case .failure(let failure):
                    print("error -> ", failure)
                    // 에러가 UnsplashError인지 확인 후 메시지 출력
                    if let unsplashError = failure as? UnsplashError {
                        let alert = UIAlertController.setErrorAlert(unsplashError.errorMessage)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController.setErrorAlert("알 수 없는 에러")
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            print("데이터 로드 완료")
            self?.collectionView.reloadData()
        }
        // 1분
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            self.oneMinutePassed = true
        }
    }

    private func getThreeRandomTopic() {
        var categories = Array(0...15)
        self.topics.removeAll()
        for _ in 0..<3 {
            let index = categories.randomElement()!
            topics.append(topicsTest[index])
            let idx = categories.firstIndex(of: index)!
            categories.remove(at: idx)
        }
    }
}

// MARK: @objc
extension TopicViewController {
    @objc private func handleRefreshControl() {
        print(#function)
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
        if oneMinutePassed {
            getThreeRandomTopic()
            self.oneMinutePassed = false
        }
    }
}
