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
          VStack {
             HStack {
                TextField("Country",text: $country)
                   .textFieldStyle(.roundedBorder)
                   .foregroundColor(.secondary)
                TextField("City",text: $city)
                   .textFieldStyle(.roundedBorder)
                   .foregroundColor(.secondary)
                                   
             }
             Button("Plan It") {
                let newTrip = Trip(country: country, city: city)
                context.insert(newTrip)
                dismiss()
             }
             .frame(maxWidth: .infinity, alignment: .trailing)
             .buttonStyle(.borderedProminent)
             .padding(.vertical)
             .disabled(country.isEmpty || city.isEmpty)
             .navigationTitle("New Trip")
             .navigationBarTitleDisplayMode(.automatic)
             .toolbar {
                ToolbarItem(placement: .bottomBar) {
                   Button("Cancel") {
                      dismiss()
                   }
                   .buttonStyle(.borderedProminent)
                }
             }
          }
          .formStyle(.grouped)
          .padding()
       }
    }

}

#Preview {
    NewTripView()
}
