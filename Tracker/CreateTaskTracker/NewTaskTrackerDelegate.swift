//
//  NewtaskTrackerDelegate.swift
//  Tracker
//
//  Created by Amir on 03.10.2026.
//

protocol NewTaskTrackerDelegate: AnyObject{
    func didCreateTracker(tracker: Tracker, category: String)
}
