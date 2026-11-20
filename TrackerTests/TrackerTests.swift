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
        let vc = TrackerViewController()
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    @Test @MainActor
    func viewControllerLight(){
        let vc = TrackerViewController()
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }

}
