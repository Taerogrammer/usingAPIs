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
    private let topics: [String] = ["골든 아워", "비즈니스 및 업무", "건축 및 인테리어"]

    // 딕셔너리를 이용한 변환
    private let topicEnglish: [String: String] = [
        "골든 아워": "golden-hour",
        "비즈니스 및 업무": "business-work",
        "건축 및 인테리어": "architecture-interior"
    ]

    private var topicImages: [[Topic]] = Array(repeating: [], count: 3)

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureHierarchy(), configureLayout(), configureView(), configureDelegate(), fetchTopics(), configureRefreshControl()].forEach { $0 }
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

        NetworkManager.shared.fetchPhotoDetail(photoId: topicImages[indexPath.section][indexPath.item].id) { result in
            switch result {
            case .success(let value):
                detailVC.configureImage(with: self.topicImages[indexPath.section][indexPath.item].urls.small)
                detailVC.configureDetail(with: value)
                self.navigationController?.pushViewController(detailVC, animated: true)
            case .failure(let error):
                print("에러 -> ", error)
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
            dispatchGroup.enter()
            NetworkManager.shared.fetchTopic(topic: convertedTopic) { [weak self] result in
                // 끝나는 시점을 정확히 모르는 경우
                // defer: 해당 블럭의 마지막에 실행
                defer { dispatchGroup.leave() }

                switch result {
                case .success(let value):
                    self?.topicImages[index] = value
                case .failure(let error):
                    print("error -> ", error)
                }
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            print("데이터 로드 완료")
            self?.collectionView.reloadData()
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
    }
}
