//
//  ContentView.swift
//  OutlineViewCrash
//
//  Created by Konstantin Malyshev on 1/9/21.
//

//
// Shows a crash in List view that has children.
//

import SwiftUI

struct Item: Identifiable {
    let id: UUID
    let name: String
    let children: [Item]?
    
    init(id: UUID = UUID(), name: String = String(UUID().uuidString.prefix(6)), children: [Item]? = nil) {
        self.id = id
        self.name = name
        self.children = children
    }
}

class ViewModel: ObservableObject {
    
    @Published var items: [Item] = ViewModel.generateRandom()
    
    // Crash on list update when the last element is deleted
    //
    func removeLast() {
        var itemsCopy = items
        
        guard !itemsCopy.isEmpty else { return }
        itemsCopy.removeLast()
        items = itemsCopy
    }
    
    // Crash on list update
    //
    func clearAll() {
        items = []
    }
    
    static func generateRandom() -> [Item] {
        [
            .init(children: [.init(), .init()]),
            .init(children: [.init(), .init()]),
            .init(children: [.init(), .init()]),
        ]
    }
}

struct ContentView: View {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        
        VStack {
            
            // Comment out children part here and it stops crashing
            //
            List(viewModel.items, id: \.id, children: \.children) { item in
                VStack {
                    Text(item.name).padding()
                    Divider()
                }
            }
            
            Button("Clear all") {
                viewModel.clearAll()
            }
            
            Button("Remove last") {
                viewModel.removeLast()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
