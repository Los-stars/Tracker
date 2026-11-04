//
//  NewTaskIrregularTrackerViewControllerPresenter.swift
//  Tracker
//
//  Created by Amir on 05.10.2026.
//

import Foundation

final class NewTaskIrregularTrackerViewControllerPresenter{
    private var selectedDays: [WeekDay] = []
    var onDataChanged: (() -> Void)?
    var scheduleSubtitle: String? {
            guard !selectedDays.isEmpty else { return nil }
            
            if selectedDays.count == WeekDay.allCases.count {
                return "Каждый день"
            }
            
            return selectedDays
                .sorted { WeekDay.allCases.firstIndex(of: $0)! < WeekDay.allCases.firstIndex(of: $1)! }
                .map { $0.shortName }
                .joined(separator: ", ")
        }
    
    func setSelectedDays() -> Set<WeekDay>{
        Set(selectedDays)
    }
    
    func formatWeekDayToSchedule() -> Schedule?{
        guard !selectedDays.isEmpty else { return nil }
        guard selectedDays.count == WeekDay.allCases.count else { return Schedule.specific(selectedDays) }
        return Schedule.everyday
    }
    
    func selectedDaysNotEmpty() -> Bool{
        return !selectedDays.isEmpty
    }
    
    func updateSchedule(_ days: [WeekDay]){
        selectedDays = days
        onDataChanged?()
    }
    
    func checkTextRange(to text: String) -> Bool{
        if text.count > 38{
            return false
        }else{
            return true
        }
    }
}
