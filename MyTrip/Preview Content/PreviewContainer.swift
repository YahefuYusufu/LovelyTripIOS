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
   init(_ models: any PersistentModel.Type...) {
      let config = ModelConfiguration(isStoredInMemoryOnly: true)
      let schema = Schema(models)
      do {
         container = try ModelContainer(for: schema, configurations: config)
      } catch {
         fatalError("Could not create preview container")
      }
   }
   
   func addExamples(examples: [any PersistentModel]) {
      Task { @MainActor in
         examples.forEach { example in
            container.mainContext.insert(example)
         }
      }
   }
}
