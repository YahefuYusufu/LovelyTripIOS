//
//  PreviewContainer.swift
//  MyTrip
//
//  Created by yusufyakuf on 2024-01-13.
//

import Foundation
import SwiftData

struct Preview {
   let container: ModelContainer
   init() {
      let config = ModelConfiguration(isStoredInMemoryOnly: true)
      do {
         container = try ModelContainer(for: Trip.self, configurations: config)
      } catch {
         fatalError("Could not create preview container")
      }
   }
   
   func addExamples(_ examples: [Trip]) {
      Task { @MainActor in
         examples.forEach { example in
            container.mainContext.insert(example)
         }
      }
   }
}
