//
//  TrackerStore.swift
//  Tracker
//
//  Created by Amir on 16.10.2026.
//
import CoreData
import UIKit

enum TrackerStoreError: Error {
    case categoryNotFound
    case trackerAlreadyExists
}

protocol TrackerStoreDelegate: AnyObject {
    func trackerStoreDidUpdate()
}


final class TrackerStore: NSObject{
    private let context: NSManagedObjectContext
    weak var delegate: TrackerStoreDelegate?
    
    private lazy var frc: NSFetchedResultsController<TrackerCoreData> = {
        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "trackerCategory.title", ascending: true),
            NSSortDescriptor(key: "title", ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "trackerCategory.title",
            cacheName: nil)
        controller.delegate = self
        try? controller.performFetch()
        return controller
    }()

    var categories: [TrackerCategory] {
        (frc.sections ?? []).map { section in
            let trackers = (section.objects as? [TrackerCoreData] ?? []).compactMap(makeTracker)
            return TrackerCategory(title: section.name, trackers: trackers)
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    func saveTracker(tracker: Tracker, category: TrackerCategory) throws{
        let request = TrackerCategoryCoreData.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "title == %@",
            category.title
        )
        
        guard let categoryCoreData = try context.fetch(request).first else {
            throw TrackerStoreError.categoryNotFound
        }
        
        let trackerRequest = TrackerCoreData.fetchRequest()
        trackerRequest.fetchLimit = 1
        trackerRequest.predicate = NSPredicate(
            format: "id == %@",
            tracker.id as CVarArg
        )

        if try context.fetch(trackerRequest).first != nil {
            throw TrackerStoreError.trackerAlreadyExists
        }
        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.scheduleValue = tracker.schedule
        
        trackerCoreData.trackerCategory = categoryCoreData
        
        try context.save()
    }
    
    func fetchTracker() throws -> [Tracker]{
        let request = TrackerCoreData.fetchRequest()
        return try context.fetch(request).compactMap(makeTracker)
    }
    
    func deleteTracker(tracker: Tracker) throws{
        let request = TrackerCoreData.fetchRequest()
        request.fetchLimit = 1
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

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.trackerStoreDidUpdate()
    }
}
