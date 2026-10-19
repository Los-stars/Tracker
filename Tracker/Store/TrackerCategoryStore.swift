//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Amir on 16.10.2026.
//

import CoreData

final class TrackerCategoryStore{
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
//    func createTrackerCategory(trackerCategory object: TrackerCategory) throws{
//        
//        let trackerCategory = TrackerCategoryCoreData(context: context)
//        trackerCategory.title = object.title
//        trackerCategory.tracker = object.tracker
//        try context.save()
//    }
    
    func fetchTrackerCategory() throws -> [TrackerCategoryCoreData]{
        let request = TrackerCategoryCoreData.fetchRequest()
        return try context.fetch(request)
    }
    
    func deleteTrackerCategory(trackerCategory: TrackerCategoryCoreData) throws{
        context.delete(trackerCategory)
        try context.save()
    }
}
