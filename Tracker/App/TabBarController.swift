//
//  TabbarController.swift
//  Tracker
//
//  Created by Amir on 29.09.2026.
//

import UIKit

final class TabBarController: UITabBarController{
    
    override func viewDidLoad() {
        setupTabs()
        setupAppearance()
    }
    
    func setupTabs(){
        let trackersVC = TrackerViewController()
        let trackersNav = UINavigationController(rootViewController: trackersVC)
        trackersNav.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackers"), selectedImage: UIImage(named: "trackers"))
        
        let statsVC = StatisticsViewController()
        let statsNav = UINavigationController(rootViewController: statsVC)
        statsNav.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "stats"), selectedImage: UIImage(named: "stats"))
        
        viewControllers = [trackersNav, statsNav]
    }
    
    func setupAppearance(){
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .systemGray5
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = .customBlue
        tabBar.unselectedItemTintColor = .systemGray
    }
}
