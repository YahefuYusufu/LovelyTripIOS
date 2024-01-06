//
//  BooksView.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-05.
//

import SwiftUI
import SwiftData

struct TripsView: View {
   @Environment(\.modelContext) private var context
   @Query(sort: \Trip.country) private var trips: [Trip]
   @State private var createNewTrip = false
   
   var body: some View {
      NavigationStack {
         Group {
            if trips.isEmpty {
               ContentUnavailableView("You don't have any trip yet!", systemImage: "flag.checkered")
            } else {
               List {
                  ForEach(trips) { trip in
                     NavigationLink {
                        Text(trip.country)
                     } label: {
                        HStack {
                           trip.icon
                           VStack {
                              Text(trip.country).foregroundStyle(.green)
                              Text(trip.city).foregroundStyle(.secondary)
                              if let satisfaction = trip.satisfaction {
                                 HStack {
                                    ForEach(1..<satisfaction, id:\.self) { _ in
                                       Image(systemName: "star.fill")
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
         .navigationTitle("My trips")
         .toolbar {
            Button {
               createNewTrip = true
            } label: {
               Image(systemName: "plus.circle.fill")
                  .imageScale(.large)
            }
         }
         .sheet(isPresented: $createNewTrip) {
            NewTripView()
               .presentationDetents([.medium,.large,.fraction(0.75)])
               .presentationCornerRadius(28)
         }
      }
   }
}





#Preview {
   TripsView()
      .modelContainer(for: Trip.self, inMemory: true)
}
