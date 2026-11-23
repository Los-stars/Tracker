//
//  Tracker.swift
//  Tracker
//
//  Created by Amir on 01.10.2026.
//

import Foundation
import UIKit

struct Tracker{
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: Schedule
    let isPinned: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        color: UIColor,
        emoji: String,
        schedule: Schedule,
        isPinned: Bool = false
    ) {
        self.id = id
        self.title = title
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.isPinned = isPinned
    }
}
