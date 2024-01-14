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
                     
                     VStack(alignment: .leading,spacing:10) {
                        Text(trip.country).foregroundStyle(.green)
                        Text(trip.city).foregroundStyle(.secondary)
                        if let satisfaction = trip.satisfaction {
                           HStack {
                              ForEach(1..<satisfaction, id: \.self) { _ in
                                 Image(systemName: "heart.fill")
                                    .imageScale(.medium)
                                    .foregroundStyle(.green)
                              }
                           }
                        }
                     }
                     .frame(width: 100, height: 50, alignment: .center)
                     VStack() {
                  
                        Image("firstPage")
                           .resizable()
                           .scaledToFit()
                           .frame(width: 80, height: 80, alignment: .leading)
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

#Preview {
   let preview = Preview(Trip.self)
   preview.addExamples(examples: Trip.sampleTrips)
   return NavigationStack {
      TripList(sorting: .status,filterString: "")
   }
   .modelContainer(preview.container)
}
