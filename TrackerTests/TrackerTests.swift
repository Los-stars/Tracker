//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Amir on 24.09.2026.
//

import Testing
@testable import Tracker
import SnapshotTesting
import UIKit

struct TrackerTests {

    @Test @MainActor
    func viewControllerDark(){
        let vc = makeViewController()
        assertSnapshot(of: vc,  as: .image(on: .iPhoneX, traits: UITraitCollection(userInterfaceStyle: .dark)))
    }
    
    @Test @MainActor
    func viewControllerLight(){
        let vc = makeViewController()
        assertSnapshot(of: vc,  as: .image(on: .iPhoneX, traits: UITraitCollection(userInterfaceStyle: .light)))
    }
    
    private func makeViewController() -> TrackerViewController {
        let vc = TrackerViewController()
        vc.loadViewIfNeeded()
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let fixedDate = calendar.date(from: DateComponents(year: 2026, month: 1, day: 1))!
        
        vc.trackerDate.timeZone = calendar.timeZone
        vc.trackerDate.locale = Locale(identifier: "ru_RU")
        vc.trackerDate.setDate(fixedDate, animated: false)
        vc.presenter.updateDate(date: fixedDate)
        
        return vc
    }
}
