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
   private let adaptiveColumn = [
      GridItem(.adaptive(minimum: 150, maximum: .infinity))
   ]
   
   var body: some View {
      //      Group {
      
//      List {
         ScrollView{
            LazyVGrid(columns: adaptiveColumn, spacing: 15) {
               ForEach(trips) { trip in
                  NavigationLink {
                     EditView(trip:trip)
                  } label: {
                     VStack() {
//                        Button("delete")
                        Image("firstPage")
                           .resizable()
                           .scaledToFill()
                           .frame(width: 80, height: 140, alignment: .top)
                           HStack(){
                              Text(trip.country).bold()
                              Text(trip.city).foregroundStyle(.secondary).font(.caption)
                           }
                           if let satisfaction = trip.satisfaction {
                              HStack {
                                 ForEach(1..<satisfaction, id: \.self) { _ in
                                    Image(systemName: "heart.fill")
                                       .imageScale(.medium)
                                       .foregroundStyle(Color.red)
                                       .padding(.vertical,3)
                                 }
                              }
                           }
                           
                     }
                     
                  }
                  
                  .frame(width:180,height: 240, alignment: .center)
//                  .background(Color.white).cornerRadius(20)
                  
                  .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .quaternarySystemFill), lineWidth: 2))
                  
                  .padding(5)
                  
               }
               
               .onDelete { indexSet in
                  indexSet.forEach { index in
                     let trip = trips[index]
                     context.delete(trip)
                  }
               }
            }
            
         }
//         .background(Color("backgroud"))
                  

//      }
//      .background {
//         Image("WelcomePage")
//            .resizable()
//            .scaledToFill()
//            .ignoresSafeArea(.all)
//      }
//      .scrollContentBackground(.hidden)
   }
   func deleteItem(_ indexSet: IndexSet) {
      for index in indexSet {
         let trip = trips[index]
         context.delete(trip)
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
