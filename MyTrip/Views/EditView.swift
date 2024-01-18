//
//  EditView.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-13.
//

import SwiftUI

struct EditView: View {
   let trip: Trip
   @Environment(\.modelContext) private var context
   @Environment(\.dismiss) private var dismiss
   @State private var status: Status
   @State private var satisfiction: Int?
   @State private var country = ""
   @State private var city = ""
   @State private var sysnopsis = ""
   @State private var tripAdded = Date.distantPast
   @State private var tripStarted = Date.distantPast
   @State private var tripCompleted = Date.distantPast
   @State private var showGeneres = false

   init(trip: Trip) {
      self.trip = trip
      _status = State(initialValue: Status(rawValue: trip.status)!)
   }
   var body: some View {
      HStack() {
         Text("Status")
            .padding()
            .background(Color.cyan)
            .foregroundColor(Color.white)
            .bold()
            .cornerRadius(15)
         Spacer()
         Picker("Status",selection: $status) {
            ForEach(Status.allCases) { status in
               Text(status.desc).tag(status)
            }
         }
         .buttonStyle(.bordered)
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal,20)
      Divider()
      VStack(alignment: .leading) {
         GroupBox {
            LabeledContent {
               switch status {
                  case .inPlan:
                     DatePicker("", selection: $tripAdded, displayedComponents: .date)
                  case .inProgress, .completed:
                     DatePicker("", selection: $tripAdded, in: ...tripStarted, displayedComponents: .date)
               }

         } label: {
            Text("Trip Added")
               .padding()
               .background(Color.green)
               .foregroundColor(Color.white)
               .bold()
               .cornerRadius(15)
         }
            if status == .inProgress || status == .completed {
               LabeledContent {
                  DatePicker("", selection: $tripStarted,in: tripAdded..., displayedComponents: .date)
               } label: {
                  Text("Trip Started")
                     .padding()
                     .background(Color.green)
                     .foregroundColor(Color.white)
                     .bold()
                     .cornerRadius(15)
               }
            }
            if status == .completed {
               LabeledContent {
                  DatePicker("", selection: $tripCompleted,in: tripStarted..., displayedComponents: .date)
               } label: {
                  Text("Trip Completed")
                     .padding()
                     .background(Color.green)
                     .foregroundColor(Color.white)
                     .bold()
                     .cornerRadius(15)
               }
            }
         }
         .padding()
         .foregroundColor(.secondary)
         .onChange(of: status) { oldValue, newValue in
            if newValue == .inPlan {
               tripStarted = Date.distantPast
               tripCompleted = Date.distantPast
            } else if newValue == .inProgress && oldValue == .completed {
               // from completed to inProgress
               tripCompleted = Date.distantPast
            } else if newValue == .inProgress && oldValue == .inPlan {
               //Trip has been started
               tripStarted = Date.now
            } else if newValue == .completed && oldValue == .inPlan {
               //Forgot to start the trip
               tripCompleted = Date.now
               tripStarted = tripAdded
            } else {
               //completed
               tripCompleted = Date.now
            }
         }
         Divider()
         LabeledContent {
            RatingsView(maxRating: 5, currentRating: $satisfiction, width: 30)
         } label: {
            Text("Satisfy")
         }
         LabeledContent {
            TextField("", text: $country)
            
         } label: {
            Text("Country").foregroundStyle(.secondary).bold()
         }
         LabeledContent {
            TextField("", text: $city)
         } label: {
            Text("City").foregroundStyle(.secondary).bold()
         }
         HStack {
            Button("Geners",systemImage: "flag.filled.and.flag.crossed") {
               showGeneres.toggle()
            }
            .sheet(isPresented: $showGeneres) {
               GenresView(trip: trip)
            }
            NavigationLink {
               QuetesList(trip: trip)
            } label: {
               let count = trip.quetos?.count ?? 0
               Label("^[\(count) Place](inflect: true)", systemImage: "paperplane.fill")
            }
         }
         .buttonStyle(.bordered)
         .frame(maxWidth: .infinity, alignment: .trailing)
         .padding(.horizontal)

         Divider()
         Text("Summary").foregroundStyle(.secondary).bold()
         TextEditor(text: $sysnopsis)
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
          .bold()
         //importtant, useful
         if let genres = trip.genres {
            ViewThatFits {
               ScrollView(.horizontal,showsIndicators: false) {
                  GenresStackView(genres: genres)
               }
            }
         }
      }
      .padding()
      .textFieldStyle(.roundedBorder)
      .navigationTitle(country)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
         if changed {
            Button("Update") {
               trip.status = status.rawValue
               trip.satisfaction = satisfiction
               trip.country = country
               trip.city = city
               trip.sysnopsis = sysnopsis
               trip.tripAdded = tripAdded
               trip.tripStarted = tripStarted
               trip.tripCompleted = tripCompleted
               dismiss()
            }
            .buttonStyle(.bordered)
            .bold()
         }
      }
      .onAppear {
//         status = Status(rawValue: trip.status)!
         satisfiction = trip.satisfaction
         country = trip.country
         city = trip.city
         sysnopsis = trip.sysnopsis
         tripAdded = trip.tripAdded
         tripStarted = trip.tripStarted
         tripCompleted = trip.tripCompleted
      }
   }
   
   var changed: Bool {
      status != Status(rawValue: trip.status)!
      || satisfiction != trip.satisfaction
      || country != trip.country
      || city != trip.city
      || sysnopsis != trip.sysnopsis
      || tripAdded != trip.tripAdded
      || tripStarted != trip.tripStarted
      || tripCompleted != trip.tripCompleted
   }
}



#Preview {
   let preview = Preview(Trip.self)
   return NavigationStack {
      EditView(trip: Trip.sampleTrips[4])
         .modelContainer(preview.container)
   }
}
