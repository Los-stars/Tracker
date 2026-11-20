import Foundation

final class EditTrackerViewControllerPresenter{
    var completedTrackers: [TrackerRecord] = []
    var trackerRecordStore: TrackerRecordStore?
    
    private(set) var selectedDays: [WeekDay] = []
    var scheduleSubtitle: String? {
        guard !selectedDays.isEmpty else { return nil }
        if selectedDays.count == WeekDay.allCases.count { return "Каждый день" }
        return selectedDays
            .sorted { WeekDay.allCases.firstIndex(of: $0)! < WeekDay.allCases.firstIndex(of: $1)! }
            .map { $0.shortName }
            .joined(separator: ", ")
    }
    
    var schedule: Schedule {
        selectedDays.count == WeekDay.allCases.count ? .everyday : .specific(selectedDays)
    }

    func setSchedule(_ days: [WeekDay]) {
        selectedDays = days
        onDataChanged?()
    }
    
    var onDataChanged: (() -> Void)?
    
    func viewDidLoad() {
        loadRecords()
    }
    
    func selectedDaysNotEmpty() -> Bool{
        return !selectedDays.isEmpty
    }
    
    func setSchedule(_ schedule: Schedule) {
        switch schedule {
        case .everyday:
            selectedDays = WeekDay.allCases
        case .specific(let days):
            selectedDays = days
        }
    }
    
    func setSelectedDays() -> Set<WeekDay>{
        Set(selectedDays)
    }
    
    func updateSchedule(_ days: [WeekDay]){
        selectedDays = days
        onDataChanged?()
    }
    
    func loadRecords() {
        guard let trackerRecordStore else { return }
        do {
            completedTrackers = try trackerRecordStore.fetchTrackerRecord()
            onDataChanged?()
        } catch {
            print("Core Data error: \(error)")
        }
    }
}
