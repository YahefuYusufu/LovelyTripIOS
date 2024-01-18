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
   @State var selectedTrip: Trip?
   @State private var selectedCityPicData: Data?
   
   
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
      ScrollView {
         LazyVGrid(columns: adaptiveColumn, spacing: 5) {
            ForEach(trips) { trip in
               NavigationLink {
                  EditView(trip:trip)
               } label: {
                  VStack(spacing:5){
                     
                     VStack(alignment: .trailing, spacing: 3) {
                        Button("",systemImage: "trash.fill",role: .destructive) {
                           context.delete(trip)
                        }
                        .foregroundStyle(Color.gray)
                        
                        Group {
                           if let cityPicture = trip.cityPicture,
                              let uiImage = UIImage(data: cityPicture) {
                              Image(uiImage: uiImage)
                                 .resizable()
                                 .scaledToFill()
                                 .frame(width: 150, height: 120)
                                 .cornerRadius(10)
                              
                           } else {
                              Image(systemName: "photo")
                                 .resizable()
                                 .scaledToFit()
                                 .frame(width: 150, height: 140)
                                 .tint(.secondary)
                           }
                        }
                     }
                     
                     HStack(){
                        Text(trip.country).bold()
                        Text(trip.city).foregroundStyle(.secondary).font(.caption)
                     }
                     if let satisfaction = trip.satisfaction {
                        HStack {
                           ForEach(1..<satisfaction, id: \.self) { _ in
                              Image(systemName: "heart.fill")
                                 .imageScale(.medium)
                                 .foregroundStyle(Color.green)
                                 .padding(.vertical,3)
                           }
                        }
                     }
                     if let genres = trip.genres {
                        ViewThatFits {
                           ScrollView(.horizontal,showsIndicators: false) {
                              GenresStackView(genres: genres)
                           }
                        }
                        .padding(.horizontal,5)
                     }
                  }
               }
               
               .frame(width:180,height: 240, alignment: .center)
               .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .quaternarySystemFill), lineWidth: 2))
               .padding(10)
            }  
         }
      }
   }
}

#Preview {
   let preview = Preview(Trip.self)
   preview.addExamples(Trip.sampleTrips)
   return NavigationStack {
      TripList(sorting: .status,filterString: "")
   }
   .modelContainer(preview.container)
}
