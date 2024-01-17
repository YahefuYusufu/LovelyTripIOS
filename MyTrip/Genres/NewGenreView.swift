//
//  NewGenreView.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-16.
//

import SwiftUI

struct NewGenreView: View {
   @Environment(\.dismiss) private var dismiss
   @Environment(\.modelContext) private var context
   @State private var name = ""
   @State private var color = Color.red
   
    var body: some View {
       NavigationStack {
          Form {
             TextField("name", text: $name)
             ColorPicker("Give a color..",selection: $color,supportsOpacity: false)
             Button("Create") {
                let newGenre = Genre(name: name, color: color.toHexString()!)
                context.insert(newGenre)
                dismiss()
             }
             .buttonStyle(.borderedProminent)
             .frame(maxWidth: .infinity,alignment: .trailing)
             .disabled(name.isEmpty)
          }
          .padding()
          .navigationTitle("New Genre")
          .navigationBarTitleDisplayMode(.inline)
       }
    }
}

#Preview {
    NewGenreView()
}
