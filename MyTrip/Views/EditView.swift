//
//  EditView.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-13.
//

import SwiftUI
import PhotosUI

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
   @State private var selectedCityPic: PhotosPickerItem?
   @State private var selectedCityPicData: Data?
   
   init(trip: Trip) {
      self.trip = trip
      _status = State(initialValue: Status(rawValue: trip.status)!)
   }
   var body: some View {
      HStack() {
         Text("Status")
            .bold()
         
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
                  .bold()
                  .foregroundStyle(.primary)
            }
            if status == .inProgress || status == .completed {
               LabeledContent {
                  DatePicker("", selection: $tripStarted,in: tripAdded..., displayedComponents: .date)
               } label: {
                  Text("Trip Started")
                     .bold()
                     .foregroundStyle(.primary)
               }
            }
            if status == .completed {
               LabeledContent {
                  DatePicker("", selection: $tripCompleted,in: tripStarted..., displayedComponents: .date)
               } label: {
                  Text("Trip Completed")
                     .bold()
                     .foregroundStyle(.primary)
               }
            }
         }
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
         HStack {
            VStack {
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
            }
            PhotosPicker(
               selection: $selectedCityPic,
               matching:.images,
               photoLibrary: .shared()) {
                  Group {
                     if let selectedCityPicData,
                        let uiImage = UIImage(data: selectedCityPicData) {
                        Image(uiImage: uiImage)
                           .resizable()
                           .scaledToFit()
                     } else {
                        Image(systemName: "photo")
                           .resizable()
                           .scaledToFit()
                           .tint(.secondary)
                     }
                  }
                  .frame(width: 75,height:100)
                  .overlay(alignment: .bottomTrailing) {
                     if selectedCityPicData != nil {
                        Button {
                           selectedCityPic = nil
                           selectedCityPicData = nil
                        } label: {
                           Image(systemName: "x.circle.fill")
                              .foregroundStyle(.red)
                        }
                     }
                  }
               }
         }
         VStack{
            LabeledContent {
               RatingsView(maxRating: 5, currentRating: $satisfiction, width: 30)
            } label: {
               Text("Satisfy")
                  .padding(5)
                  .background(Color.green)
                  .foregroundStyle(Color.white)
                  .bold()
                  .cornerRadius(10)
            }
         }
         .padding(.top,5)
         HStack {
            Button("Like",systemImage: "flag.filled.and.flag.crossed") {
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
         .padding()
         
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
               //swiftdata will automaticaly update the image here
               trip.cityPicture = selectedCityPicData
               dismiss()
            }
            .buttonStyle(.bordered)
            .bold()
         }
      }
      .onAppear {
         satisfiction = trip.satisfaction
         country = trip.country
         city = trip.city
         sysnopsis = trip.sysnopsis
         tripAdded = trip.tripAdded
         tripStarted = trip.tripStarted
         tripCompleted = trip.tripCompleted
         selectedCityPicData = trip.cityPicture
      }
      .task(id: selectedCityPic) {
         if let data = try? await selectedCityPic?.loadTransferable(type: Data.self) {
            selectedCityPicData = data
         }
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
      || selectedCityPicData != trip.cityPicture
   }
}


#Preview {
   let preview = Preview(Trip.self)
   return NavigationStack {
      EditView(trip: Trip.sampleTrips[4])
         .modelContainer(preview.container)
   }
}
