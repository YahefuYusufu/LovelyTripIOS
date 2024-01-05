//
//  Item.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-05.
//

import SwiftUI
import SwiftData

@Model
class Trip {
   var country: String
   var city: String
   var summary: String = ""
   var departureDate: Date
   var arrivalDate: Date
   var returnDate: Date
   var totalDays: Int?
   var satisfaction: Int?
   var status: Status
   
   init(
      country: String,
      city: String,
      summary: String = "",
      departureDate: Date = Date.now,
      arrivalDate: Date = Date.distantPast,
      returnDate: Date = Date.distantPast,
      totalDays: Int? = nil,
      satisfaction: Int? = nil,
      status: Status = .departureDate
   ) {
      self.country = country
      self.city = city
      self.summary = summary
      self.departureDate = departureDate
      self.arrivalDate = arrivalDate
      self.returnDate = returnDate
      self.totalDays = totalDays
      self.satisfaction = satisfaction
      self.status = status
   }
   
   
   
   
   var icon: Image {
      switch status {
         case .departureDate:
            Image(systemName:"airplane.departure")
         case .arrivalDate:
            Image(systemName:"airplane.arrival")
         case .returnDate:
            Image(systemName: "return")
      }
   }
   
   
   
   enum Status: Int, Identifiable, Codable, CaseIterable  {
      case departureDate, arrivalDate,returnDate
      var id: Self {
         self
      }
      var desc: String {
         switch self{
            case .departureDate: "Departure Date"
            case .arrivalDate: "Arrive Date"
            case .returnDate: "Return Date"
         }
      }
      
   }
}
