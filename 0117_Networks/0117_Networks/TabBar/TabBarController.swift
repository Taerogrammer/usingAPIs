//
//  TabBarController.swift
//  0117_Networks
//
//  Created by 김태형 on 1/17/25.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureTabBarAppearance()
    }
}

// MARK: configure
extension TabBarController {
    private func configureTabBar() {
        let topicVC = TopicViewController()
        let pictureSearchVC = PictureSearchViewController()
        let pictureSearchNav = UINavigationController(rootViewController: pictureSearchVC)

        topicVC.tabBarItem.title = "토픽"
        topicVC.tabBarItem.image = UIImage(systemName: "list.clipboard")
        topicVC.tabBarItem.selectedImage = UIImage(systemName: "list.clipboard.fill")

        pictureSearchNav.tabBarItem.title = "사진"
        pictureSearchNav.tabBarItem.image = UIImage(systemName: "photo")
        pictureSearchNav.tabBarItem.selectedImage = UIImage(systemName: "photo.fill")

        setViewControllers([topicVC, pictureSearchNav], animated: true)
    }
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .blue
    }
}
