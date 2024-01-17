//
//  GenresView.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-16.
//

import SwiftUI
import SwiftData

struct GenresView: View {
   @Environment(\.modelContext) private var context
   @Environment(\.dismiss) private var dismiss
   @Bindable var trip: Trip
   @Query(sort: \Genre.name) var genres: [Genre]
   @State private var newGenre = false
   
   var body: some View {
      NavigationStack {
         Group {
            if genres.isEmpty {
               ContentUnavailableView {
                  Image(systemName: "flag.filled.and.flag.crossed")
                     .font(.largeTitle)
               } description: {
                  Text("You need to create some genres first.")
               } actions: {
                  Button("Create Genre") {
                     newGenre.toggle()
                  }
                  .buttonStyle(.borderedProminent)
               }
            } else {
               List {
                  ForEach(genres) { genre in
                     HStack {
                        if let tripGenres = trip.genres {
                           if tripGenres.isEmpty {
                              Button {
                                 addRemove(genre)
                              } label: {
                                 Image(systemName: "circle")
                              }
                              .foregroundStyle(genre.haxColor)
                           } else {
                              Button {
                                 addRemove(genre)
                              } label: {
                                 Image(systemName: tripGenres.contains(genre) ? "circle.fill" : "circle")
                              }
                              .foregroundStyle(genre.haxColor)
                           }
                        }
                           Text(genre.name)
                     }
                  }
                  .onDelete(perform: { indexSet in
                     indexSet.forEach { index in
                        if let bookGenres = trip.genres,
                           bookGenres.contains(genres[index]),
                           let bookGenreIndex = bookGenres.firstIndex(where: {
                              $0.id == genres[index].id}) {
                           trip.genres?.remove(at: bookGenreIndex)
                        }
                        context.delete(genres[index])
                        
                     }
                     
                  })
                  LabeledContent {
                     Button {
                        newGenre.toggle()
                     } label: {
                        Image(systemName: "plus.circle.fill")
                           .imageScale(.large)
                     }
                     .buttonStyle(.borderedProminent)
                  } label: {
                     Text("Create new Genre")
                        .font(.caption).foregroundColor(.secondary)
                  }
               }
               .listStyle(.plain)
            }
         }
         .navigationTitle(trip.city)
         .sheet(isPresented: $newGenre){
            NewGenreView()
         }
         .toolbar {
            ToolbarItem(placement: .bottomBar) {
               Button("Back") {
                  dismiss()
               }
               .buttonStyle(.borderedProminent)
            }
         }
      }
   }
   func addRemove(_ genre: Genre) {
      if let tripGenres = trip.genres {
         if tripGenres.isEmpty {
            trip.genres?.append(genre)
         } else {
            if tripGenres.contains(genre),
               let index = tripGenres.firstIndex(where: {$0.id == genre.id}) {
               trip.genres?.remove(at: index)
            } else {
               trip.genres?.append(genre)
            }
         }
      }
   }
}

#Preview {
   let preview = Preview(Trip.self)
   let trips = Trip.sampleTrips
   let genres = Genre.sampleGenres
   preview.addExamples(trips)
   preview.addExamples(genres)
   //have some issue with this previews ,genres
   trips[1].genres?.append(genres[0])
   return GenresView(trip: trips[1])
      .modelContainer(preview.container)
}
