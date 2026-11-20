//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Amir on 16.10.2026.
//

import CoreData
import UIKit

protocol TrackerCategoryStoreProtocol {
    func fetchCategoryTitles() throws -> [String]
    func createCategory(title: String) throws
    func deleteCategory(title: String) throws
    func updateCategory(oldTitle: String, newTitle: String) throws
}

final class TrackerCategoryStore: TrackerCategoryStoreProtocol{
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchCategoryTitles() throws -> [String]{
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return try context.fetch(request).compactMap({ $0.title })
    }
    
    func createCategory(title: String) throws{
        guard try fetchCategoryCoreData(with: title) == nil else { return }
        let category = TrackerCategoryCoreData(context: context)
        category.title = title
        try context.save()
    }
    
    func deleteCategory(title: String) throws{
        guard let category = try fetchCategoryCoreData(with: title) else { return }
        context.delete(category)
        try context.save()
    }
    
    func updateCategory(oldTitle: String, newTitle: String) throws {
        guard oldTitle != newTitle else { return }
        guard try fetchCategoryCoreData(with: newTitle) == nil else {
            return
        }
        guard let category = try fetchCategoryCoreData(with: oldTitle) else { return }
        category.title = newTitle
        try context.save()
    }
    
    func createTrackerCategory(trackerCategory object: TrackerCategory) throws{
        let trackerCategory = TrackerCategoryCoreData(context: context)
        trackerCategory.title = object.title
        
        for tracker in object.trackers{
            let request = TrackerCoreData.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
            
            let trackerCoreData: TrackerCoreData
            if let existingTracker = try context.fetch(request).first{
                trackerCoreData = existingTracker
            }else{
                trackerCoreData = TrackerCoreData(context: context)
                trackerCoreData.id = tracker.id
                trackerCoreData.color = tracker.color
                trackerCoreData.emoji = tracker.emoji
                trackerCoreData.title = tracker.title
                trackerCoreData.scheduleValue = tracker.schedule
            }
            trackerCoreData.trackerCategory = trackerCategory
        }
        
        try context.save()
    }
    
    func fetchTrackerCategory() throws -> [TrackerCategory]{
        let request = TrackerCategoryCoreData.fetchRequest()
        return try context.fetch(request).compactMap(makeTrackerCategory)
    }
    
    func deleteTrackerCategory(trackerCategory: TrackerCategory) throws{
        let request = TrackerCategoryCoreData.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "title == %@", trackerCategory.title)
        guard let category = try context.fetch(request).first else {
            return
        }

        context.delete(category)
        try context.save()
    }
    
    private func fetchCategoryCoreData(with title: String) throws -> TrackerCategoryCoreData? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "title == %@", title)
        return try context.fetch(request).first
    }
    
    private func makeTrackerCategory(_ object: TrackerCategoryCoreData) -> TrackerCategory?{
        guard let title = object.title else { return nil }
        
        let trackerObjects = object.trackers as? Set<TrackerCoreData> ?? []
        
        let trackers = trackerObjects.compactMap { tracker -> Tracker? in
            guard let id = tracker.id,
                  let title = tracker.title,
                  let color = tracker.color as? UIColor,
                  let emoji = tracker.emoji,
                  let schedule = tracker.scheduleValue
            else {
                return nil
            }
            
            return Tracker(
                id: id,
                title: title,
                color: color,
                emoji: emoji,
                schedule: schedule
            )
        }
        
        return TrackerCategory(
            title: title,
            trackers: trackers
        )
    }
    
    func createDefaultCategoryIfNeeded() throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "title == %@",
            "Домашний уют"
        )

        guard try context.fetch(request).isEmpty else {
            return
        }

        let category = TrackerCategoryCoreData(context: context)
        category.title = "Домашний уют"

        try context.save()
    }
}
