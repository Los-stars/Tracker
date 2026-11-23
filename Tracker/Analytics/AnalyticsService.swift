import Foundation
import AppMetricaCore
enum AnalyticsEvent: String{
    case open
    case close
    case click
}

enum AnalyticsScreen: String {
    case main = "Main"
}

enum AnalyticsItem: String{
    case addTrack = "add_track"
    case track
    case filter
    case edit
    case delete
}

final class AnalyticsService{
    static let shared = AnalyticsService()
    private init() {}
    
    func report(event: AnalyticsEvent, screen: AnalyticsScreen, item: AnalyticsItem? = nil){
        var params: [AnyHashable:Any] = [
            "event": event.rawValue,
            "screen": screen.rawValue
        ]
        
        if let item {
            params["item"] = item.rawValue
        }
        
        print("ANALYTICS:", params)
        
        AppMetrica.reportEvent(name: event.rawValue, parameters: params, onFailure: { error in
            print("ANALYTICS ERROR:", error.localizedDescription)
        })
    }
}
