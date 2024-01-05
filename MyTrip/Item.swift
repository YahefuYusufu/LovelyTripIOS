//
//  Item.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-05.
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
