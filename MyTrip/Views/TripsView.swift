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
         VStack {
            Text("test")
         }
         .padding()
         .navigationTitle("Add your trip.")
         .toolbar {
            Button {
               createNewTrip = true
            } label: {
               Image(systemName: "plus")
            }
         }
         .sheet(isPresented: $createNewTrip) {
            NewTripView()
               .presentationDetents([.medium])
         }
      }
   }
}


#Preview {
   TripsView()
      .modelContainer(for: Trip.self,inMemory: true)
   
}
