//
//  Genre.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-16.
//

import SwiftUI
import SwiftData

@Model
class Genre {
   var name: String
   var color: String
   var trips: [Trip]?
   
   init(name: String, color: String) {
      self.name = name
      self.color = color
   }
   
   var haxColor: Color {
      Color(hex: self.color) ?? .red
   }
}
