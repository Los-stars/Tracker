//
//  Tracker.swift
//  Tracker
//
//  Created by Amir on 01.10.2026.
//

import Foundation
import UIKit

struct Tracker{
    let id: UUID = UUID()
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: Schedule
}
