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
    
    private var visibleTrackers: [Tracker] {
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        let weekDay = WeekDay.from(calendarWeekday: weekday)
        
        return categories
            .flatMap({ $0.trackers })
            .filter({ tracker in
                switch tracker.schedule{
                case .everyday:
                    return true
                case .specific(let days):
                    return days.contains(weekDay)
                }
            })
    }
    
    func setInitialData() {
        let today = Calendar.current.component(.weekday, from: Date())
        let weekDay = WeekDay.from(calendarWeekday: today)
        let tracker = Tracker(title: "hello", color: .green, emoji: "😪", schedule: .specific([weekDay]))
        addTracker(tracker, toCategory: "Домашний уют")
    }
    
    func numberOfVisibleTrackers() -> Int{
        visibleTrackers.count
    }
    
    func tracker(at index: Int) -> Tracker{
        visibleTrackers[index]
    }
    
    func hasVisibleTrackers() -> Bool{
        !visibleTrackers.isEmpty
    }
    
    func isTrackerCompleted(_ tracker: Tracker, on date: Date) -> Bool {
        completedTrackers.contains {
            $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }
    
    func markTrackerCompleted(_ tracker: Tracker, on date: Date){
        if isTrackerCompleted(tracker, on: date) {
            completedTrackers.removeAll {
                $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date)
            }
        } else {
            completedTrackers.append(TrackerRecord(trackerId: tracker.id, date: date))
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
    
    func updateDate(date: Date){
        currentDate = date
        onDataChanged?()
    }
}
