//
//  TripList.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-14.
//

import SwiftUI
import SwiftData

struct TripList: View {
   @Environment(\.modelContext) private var context
   @Query private var trips: [Trip]
   init(sorting: Sorting, filterString: String) {
      let sortDescriptors: [SortDescriptor<Trip>] = switch sorting {
         case .status:
            [SortDescriptor(\Trip.status), SortDescriptor(\Trip.country)]
         case .country:
            [SortDescriptor(\Trip.country)]
         case .city:
            [SortDescriptor(\Trip.city)]
      }
      let predicate = #Predicate<Trip> { trip in
         trip.country.localizedStandardContains(filterString)
         || trip.city.localizedStandardContains(filterString)
         || filterString.isEmpty
      }
      _trips = Query(filter: predicate, sort: sortDescriptors)
   }
   var body: some View {
      Group {
         if trips.isEmpty {
            ContentUnavailableView("You don't have any trip yet!", systemImage: "flag.checkered")
         } else {
            List {
               ForEach(trips) { trip in
                  NavigationLink {
                     EditView(trip:trip)
                  } label: {
                     HStack(spacing: 10) {
                        trip.icon
                           .bold()
                           .foregroundStyle(Color.white)
                           .padding()
                           .background(Color.cyan)
                           .cornerRadius(10)
                        
                        
                        VStack(alignment: .leading) {
                           Text(trip.country).foregroundStyle(.green).font(.title).bold()
                           Text(trip.city).foregroundStyle(.secondary).font(.title2)
                           if let satisfaction = trip.satisfaction {
                              HStack {
                                 ForEach(0..<satisfaction, id: \.self) { _ in
                                    Image(systemName: "hand.thumbsup.fill")
                                       .imageScale(.medium)
                                       .foregroundStyle(.green)
                                 }
                              }
                           }
                        }
                     }
                  }
               }
               .onDelete { indexSet in
                  indexSet.forEach { index in
                     let trip = trips[index]
                     context.delete(trip)
                  }
               }
            }
            .listStyle(.plain)
         }
      }
   }
}

#Preview {
   let preview = Preview(Trip.self)
   preview.addExamples(examples: Trip.sampleTrips)
   return NavigationStack {
      TripList(sorting: .status,filterString: "")
   }
   .modelContainer(preview.container)
}
