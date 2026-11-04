//
//  OnBoardingViewController.swift
//  Tracker
//
//  Created by Amir on 27.10.2026.
//

import UIKit

class OnBoardingViewController: UIPageViewController {
    
    lazy var pages: [UIViewController] = {
        let firstVC = OnBoardingOneViewController()
        let secondVC = OnBoardingTwoViewController()
        return [firstVC, secondVC]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .blackDay
        pageControl.pageIndicatorTintColor = UIColor.blackDay.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.backgroundColor = .blackDay
        button.setTitleColor(.whiteDay, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        return button
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: options)
    }

    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let first = pages.first{
            setViewControllers([first], direction: .forward, animated: true)
        }
        
        setupUI()
    }
    
    func setupUI(){
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func buttonTap(){
        finishOnBoarding()
    }
    
    func finishOnBoarding(){
        guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else { return }
        let tabBarVC = TabBarController()
        let navigationViewController = UINavigationController(rootViewController: tabBarVC)
        navigationViewController.isNavigationBarHidden = true
        
        window.rootViewController = navigationViewController
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension OnBoardingViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            finishOnBoarding()
            return nil
        }
        
        return pages[nextIndex]
    }
}

extension OnBoardingViewController: UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController){
            pageControl.currentPage = currentIndex
        }
    }
}
