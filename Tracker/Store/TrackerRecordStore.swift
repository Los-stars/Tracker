//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Amir on 16.10.2026.
//

import CoreData

final class TrackerRecordStore{
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createTrackerRecord(trackerRecord object: TrackerRecord) throws{
        let trackerRequest = TrackerCoreData.fetchRequest()
        trackerRequest.fetchLimit = 1
        trackerRequest.predicate = NSPredicate(
            format: "id == %@",
            object.trackerId as CVarArg
        )
        
        guard let trackerCoreData = try context.fetch(trackerRequest).first else {
            return
        }
        
        let trackerRecord = TrackerRecordCoreData(context: context)
        trackerRecord.trackerId = object.trackerId
        trackerRecord.date = object.date
        
        trackerRecord.tracker = trackerCoreData
        try context.save()
    }
    
    func fetchTrackerRecord() throws -> [TrackerRecord]{
        let request = TrackerRecordCoreData.fetchRequest()
        return try context.fetch(request).compactMap(makeTrackerRecord)
    }
    
    func deleteTrackerRecord(trackerRecord: TrackerRecord) throws{
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerId == %@ AND date == %@", trackerRecord.trackerId as CVarArg, trackerRecord.date as NSDate)
        try context.fetch(request).forEach(context.delete)
        try context.save()
    }
    
    private func makeTrackerRecord(_ object: TrackerRecordCoreData) -> TrackerRecord?{
        guard let id = object.trackerId,
              let date = object.date
        else { return nil }
        
        return TrackerRecord(trackerId: id, date: date)
    }
}
