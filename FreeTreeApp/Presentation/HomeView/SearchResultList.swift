//
//  SearchResultList.swift
//  FreeTreeApp
//
//  Created by Cesar Augusto Barros on 05/07/22.
//

import Foundation
import SwiftUI

struct SearchResultList: View {
    @Binding var searchingFor: String
    let trees: [String]
    
    init (
        trees: [String],
        searchingFor: Binding<String>
    ) {
        self.trees = trees
        self._searchingFor = searchingFor
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { tree in
                    NavigationLink (destination: Text(tree)) {
                        Text(tree)
                    }
                }
            }
        }
        .navigationTitle("Arvores")
    }
    
    var searchResults: [String] {
        if searchingFor.isEmpty {
            return trees
        } else {
            return trees.filter { $0.lowercased().contains(searchingFor.lowercased()) }
        }
    }
}
