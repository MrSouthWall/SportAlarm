//
//  Item.swift
//  SportAlarm
//
//  Created by MrSouthWall on 2025/7/14.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
