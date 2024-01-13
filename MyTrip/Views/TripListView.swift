//
//  BooksView.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-05.
//

import SwiftUI
import SwiftData

struct TripListView: View {
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
               .presentationDetents([.medium,.fraction(0.75)])
               .presentationCornerRadius(28)
         }
      }
   }
}





#Preview {
   TripListView()
      .modelContainer(for: Trip.self, inMemory: true)
}
