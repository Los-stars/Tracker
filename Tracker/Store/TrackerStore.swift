//
//  TrackerStore.swift
//  Tracker
//
//  Created by Amir on 16.10.2026.
//
import CoreData
import UIKit

final class TrackerStore{
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveTracker(tracker: Tracker) throws{
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.scheduleValue = tracker.schedule
        try context.save()
    }
    
    func fetchTracker() throws -> [Tracker]{
        let request = TrackerCoreData.fetchRequest()
        return try context.fetch(request).compactMap(makeTracker)
    }
    
    func deleteTracker(tracker: Tracker) throws{
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        try context.fetch(request).forEach(context.delete)
        try context.save()
    }
    
    private func makeTracker(_ object: TrackerCoreData) -> Tracker?{
        guard let id = object.id,
                      let title = object.title,
                      let color = object.color as? UIColor,
                      let emoji = object.emoji,
                      let schedule = object.scheduleValue as? Schedule
                else { return nil }
        return Tracker(id: id, title: title, color: color, emoji: emoji, schedule: schedule)
    }
}
