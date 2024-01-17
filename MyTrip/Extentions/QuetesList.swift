//
//  QuetesList.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-14.
//

import SwiftUI

struct QuetesList: View {
   @Environment(\.modelContext) private var modelContext
   let trip: Trip
   @State private var text = ""
   @State private var place = ""
   @State private var selectedQuote: Quote?
   var isEditing: Bool {
      selectedQuote != nil
   }
   var body: some View {
      GroupBox {
         HStack {
            LabeledContent("Place") {
               TextField("Place #", text: $place)
                  .autocorrectionDisabled()
                  .textFieldStyle(.roundedBorder)
                  .frame(width: 150)
               Spacer()
            }
            if isEditing {
               Button("Cancel") {
                  place = ""
                  text = ""
                  selectedQuote = nil
               }
               .buttonStyle(.bordered)
            }
            Button(isEditing ? "Update" : "Create") {
               if isEditing {
                  selectedQuote?.text = text
                  selectedQuote?.place = place.isEmpty ? nil : place
                  place = ""
                  text = ""
                  selectedQuote = nil
               } else {
                  let quote = place.isEmpty ? Quote(text: text) : Quote(text: text, page: place)
                  trip.quetos?.append(quote)
                  text = ""
                  place = ""
               }
            }
            .buttonStyle(.borderedProminent)
            .disabled(text.isEmpty)
         }
         TextEditor(text: $text)
            .border(Color.secondary)
            .frame(height: 100)
      }
      .padding(.horizontal)
      List {
         let sortedQuotes = trip.quetos?.sorted(using: KeyPathComparator(\Quote.creationDate)) ?? []
         ForEach(sortedQuotes) { quote in
            VStack(alignment: .leading) {
               Text(quote.creationDate, format: .dateTime.month().day().year())
                  .font(.caption)
                  .foregroundStyle(.secondary)
               Text(quote.text)
               HStack {
                  Spacer()
                  if let place = quote.place, !place.isEmpty {
                     Text("^[\(place) Places](inflect: true)")
                  }
               }
            }
            .contentShape(Rectangle())
            .onTapGesture {
               selectedQuote = quote
               text = quote.text
               place = quote.place ?? ""
            }
         }
         .onDelete { indexSet in
            withAnimation {
               indexSet.forEach { index in
                  let quote = sortedQuotes[index]
                  trip.quetos?.forEach{ bookQuote in
                     if quote.id == bookQuote.id {
                        modelContext.delete(quote)
                     }
                  }
               }
            }
         }
      }
      .listStyle(.plain)
      .navigationTitle("Place")
   }
}

#Preview {
   let preview = Preview(Trip.self)
   let trips = Trip.sampleTrips
   preview.addExamples(trips)
   
   return NavigationStack {
   QuetesList(trip: trips[3])
         .navigationBarTitleDisplayMode(.inline)
      .modelContainer(preview.container)
   }
}
