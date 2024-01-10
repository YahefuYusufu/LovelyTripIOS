//
//  MyTripApp.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-05.
//

import SwiftUI
import SwiftData

@main
struct MyTripApp: App {
//   let container: ModelContainer
   var body: some Scene {
      WindowGroup {
         TripListView()
      }
//      .modelContainer(container)
      .modelContainer(for: Trip.self)
   }
   
   init() {
//      let schema = Schema([Trip.self])
//      let config = ModelConfiguration("MyTrips",schema: schema)
//      do {
//         container = try ModelContainer(for: schema, configurations: config)
//      } catch {
//         fatalError("Could not configure the Container...!")
//      }
      print(URL.applicationSupportDirectory.path(percentEncoded: false))
   }
}
