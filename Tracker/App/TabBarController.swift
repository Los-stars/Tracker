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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let trackerPresenter = appDelegate.makeTrackerViewController()
        let trackerViewController = TrackerViewController()
        trackerViewController.presenter = trackerPresenter
        let trackersNav = UINavigationController(rootViewController: trackerViewController)
        trackersNav.tabBarItem = UITabBarItem(title: NSLocalizedString("trackers", comment: ""), image: UIImage(named: "trackers"), selectedImage: UIImage(named: "trackers"))
        
        let statsVC = StatisticsViewController()
        statsVC.trackerRecordStore = trackerPresenter.trackerRecordStore
        let statsNav = UINavigationController(rootViewController: statsVC)
        statsNav.tabBarItem = UITabBarItem(title: NSLocalizedString("statistics", comment: ""), image: UIImage(named: "stats"), selectedImage: UIImage(named: "stats"))
        
        viewControllers = [trackersNav, statsNav]
    }
    
    func setupAppearance(){
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .systemGray5
        appearance.backgroundColor = .whiteDay
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = .customBlue
        tabBar.unselectedItemTintColor = .systemGray
    }
}
