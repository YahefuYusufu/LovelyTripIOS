//
//  NewTrip.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-05.
//

import SwiftUI
import SwiftData

struct NewTripView: View {
   @Environment(\.modelContext) private var context
   @Environment(\.dismiss) var dismiss
   @State private var country = ""
   @State private var city = ""
   
   var body: some View {
      NavigationStack {
         Form{
            TextField("Country",text: $country)
            TextField("City",text: $city)
            Button("Plan It") {
               let newTrip = Trip(country: country, city: city)
               context.insert(newTrip)
               dismiss()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
            .disabled(country.isEmpty || city.isEmpty)
            .navigationTitle("Where you been?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
               ToolbarItem(placement: .topBarTrailing) {
                  Button() {
                     dismiss()
                  } label: {
                     Image(systemName: "xmark.octagon.fill")
                  }
                  .imageScale(.large)
               }
            }
         }
         
      }
   }
   
}
#Preview {
   NewTripView()
}
