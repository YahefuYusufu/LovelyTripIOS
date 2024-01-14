//
//  Quote.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-14.
//

import Foundation
import SwiftData

@Model
class Quote {
   var creationDate: Date = Date.now
   var text: String
   var place: String?
   
   init(text: String, page: String? = nil) {
       
      self.text = text
      self.place = page
   }
   
   var trip: Trip?
}
