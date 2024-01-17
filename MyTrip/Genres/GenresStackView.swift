//
//  GenersStackView.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-17.
//

import SwiftUI

struct GenresStackView: View {
   var genres: [Genre]
   var body: some View {
      HStack {
         ForEach(genres.sorted(using: KeyPathComparator(\Genre.name))) { genre in
            Text(genre.name)
               .font(.caption)
               .foregroundStyle(.white)
               .padding(3)
               .background(RoundedRectangle(cornerRadius: 5).fill(genre.haxColor))
         }
      }
   }
}

//#Preview {
//    GenresStackView()
//}
