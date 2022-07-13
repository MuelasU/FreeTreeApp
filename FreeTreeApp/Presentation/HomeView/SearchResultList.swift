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
    let trees: [TreeFB]
    
    init (
        trees: [TreeFB],
        searchingFor: Binding<String>
    ) {
        self.trees = trees
        self._searchingFor = searchingFor
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) { tree in
                    NavigationLink (destination: Text(tree.name)) {
                        Text(tree.name)
                    }
                }
            }
        }
    }
    
    var searchResults: [TreeFB] {
        if searchingFor.isEmpty {
            return trees
        } else {
            return trees.filter { $0.name.lowercased().contains(searchingFor.lowercased()) }
        }
    }
}
