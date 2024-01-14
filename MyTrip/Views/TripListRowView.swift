//
//  TripListRowView.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-14.
//

import SwiftUI

struct TripListRowView: View {
   let trip: Trip

    var body: some View {
       HStack {
          trip.icon
             .resizable()
             .scaledToFit()
             .frame(height: 70)
             .foregroundStyle(Color.white)
             .padding()
             .background(Color.cyan)
             .cornerRadius(7)
          
          VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
             Text(trip.country)
                .fontWeight(.semibold)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
             Text(trip.city)
                .font(.subheadline)
                .foregroundStyle(.secondary)
          }
             
       }
       
    }
}

#Preview {
   let preview = Preview(Trip.self)
   preview.addExamples(examples: Trip.sampleTrips)
   return TripListRowView(trip: Trip.sampleTrips[1])
      .modelContainer(preview.container)
}
