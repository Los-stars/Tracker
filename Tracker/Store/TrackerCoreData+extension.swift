//
//  CoreData+exten.swift
//  Tracker
//
//  Created by Amir on 16.10.2026.
//

import Foundation

extension TrackerCoreData{
    var scheduleValue: Schedule? {
        get{
            guard let data = schedule else { return nil }
            return try? JSONDecoder().decode(Schedule.self, from: data)
        }
        set{
            schedule = newValue.flatMap { try? JSONEncoder().encode($0) }
        }
    }
}
