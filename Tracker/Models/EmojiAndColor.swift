//
//  EmojiAndColor.swift
//  Tracker
//
//  Created by Amir on 08.10.2026.
//

import UIKit
enum NewTaskElement{
    case emoji(String)
    case color(UIColor)
}

struct NewTaskElementSection{
    let title: String
    let element: [NewTaskElement]
}
