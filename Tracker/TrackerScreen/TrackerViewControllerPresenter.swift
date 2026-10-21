//
//  TrackerViewControllerPresenter.swift
//  Tracker
//
//  Created by Amir on 02.10.2026.
//

import Foundation

final class TrackerViewControllerPresenter{
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date = Date()
    
    var onDataChanged: (() -> Void)?
    var onRecordAdded: ((TrackerRecord) -> Void)?
    var onRecordRemoved: ((TrackerRecord) -> Void)?
    
    var trackerStore: TrackerStore?
    var trackerCategoryStore: TrackerCategoryStore?
    var trackerRecordStore: TrackerRecordStore?
    
//    private var visibleTrackers: [Tracker] {
//        let weekday = Calendar.current.component(.weekday, from: currentDate)
//        let weekDay = WeekDay.from(calendarWeekday: weekday)
//        
//        return categories
//            .flatMap({ $0.trackers })
//            .filter({ tracker in
//                switch tracker.schedule{
//                case .everyday:
//                    return true
//                case .specific(let days):
//                    return days.contains(weekDay)
//                }
//            })
//    }
    
    func setInitialData(
        categories: [TrackerCategory],
        records: [TrackerRecord]
    ) {
        self.categories = categories
        self.completedTrackers = records

        onDataChanged?()
    }
    
    func viewDidLoad(){
        guard let trackerStore,
              let trackerCategoryStore,
              trackerRecordStore != nil else {
            print("Stores are not initialized")
            return
        }
        trackerStore.delegate = self
        do {
            try trackerCategoryStore.createDefaultCategoryIfNeeded()
            loadData()
        } catch {
            print("Core Data error: \(error)")
        }
    }
    
    func numberOfCatogories() -> Int{
        categories.count
    }

    func hasVisibleTrackers() -> Bool{
        categories.indices.contains { section in
            !trackers(in: section).isEmpty
            
        }
    }
    
    func isTrackerCompleted(_ tracker: Tracker, on date: Date) -> Bool {
        completedTrackers.contains {
            $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }
    
    func markTrackerCompleted(_ tracker: Tracker, on date: Date){
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: date)
            
        guard target <= today else { return }
        
        let record = TrackerRecord(trackerId: tracker.id, date: target)
        if isTrackerCompleted(tracker, on: date) {
            completedTrackers.removeAll {
                $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date)
            }
        } else {
            completedTrackers.append(record)
        }
        onDataChanged?()
    }
    
    func addTracker(_ tracker: Tracker, toCategory categoryTitle: String) {
        var newCategories = categories
        
        if let index = newCategories.firstIndex(where: { $0.title == categoryTitle }) {
            let old = newCategories[index]
            let updated = TrackerCategory(
                title: old.title,
                trackers: old.trackers + [tracker]
            )
            newCategories[index] = updated
        } else {
            newCategories.append(TrackerCategory(title: categoryTitle, trackers: [tracker]))
        }
        
        categories = newCategories
        
        onDataChanged?()
    }
    
    func completedTrackersCount(id: UUID) -> Int{
        let record = completedTrackers.filter({$0.trackerId == id})
        return record.count
    }
    
    func updateDate(date: Date){
        currentDate = date
        onDataChanged?()
    }
    
    private func trackers(in section: Int) -> [Tracker] {
        guard categories.indices.contains(section) else { return [] }
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        let weekDay = WeekDay.from(calendarWeekday: weekday)
        return categories[section].trackers.filter { tracker in
            switch tracker.schedule {
            case .everyday: return true
            case .specific(let days): return days.contains(weekDay)
            }
        }
    }

    func numberOfTrackers(in section: Int) -> Int {
        trackers(in: section).count
    }

    func tracker(at indexPath: IndexPath) -> Tracker {
        trackers(in: indexPath.section)[indexPath.item]
    }
    
    private func loadData() {
        guard let trackerStore, let trackerRecordStore else { return }
        do {
            let records = try trackerRecordStore.fetchTrackerRecord()
            setInitialData(categories: trackerStore.categories, records: records)
        } catch {
            print("Error loading trackers: \(error)")
        }
    }
}


extension TrackerViewControllerPresenter: TrackerStoreDelegate {
    func trackerStoreDidUpdate() {
        print("TrackerStore updated")
        print("Categories before:", categories.count)
        print("Categories in Store:", trackerStore?.categories.count ?? -1)
        
        loadData()
        
        print("Categories after:", categories.count)
    }
}
