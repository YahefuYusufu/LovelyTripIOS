//
//  TripSample.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-13.
//

import Foundation

extension Trip {
   static let lastWeek = Calendar.current.date(byAdding: .day, value: -7 ,to: Date.now)!
   static let lastMonth = Calendar.current.date(byAdding: .month, value: -1 ,to: Date.now)!
   static var sampleTrips: [Trip] {
      [
         Trip(country: "Sweden",
              city: "Helsingbory"),
         Trip(country: "Finland",
              city: "Helsigki"),
         Trip(country: "Natherland",
              city: "Amsterdam"),
         Trip(country: "Germany",
              city: "Berlin"),
         Trip(country: "Turkey",
              city: "Istanbul"
           ),
         Trip(country: "China",
              city: "GuangZhou"),
         Trip(country: "Tailand",
              city: "Bangkok"),
         Trip(country: "USA",
              city: "California"),
         Trip(country: "Fatherland",
              city: "MyHome")
      ]
   }
}
