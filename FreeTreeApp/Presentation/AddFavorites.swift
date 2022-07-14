//
//  AddFavorites.swift
//  FreeTreeApp
//
//  Created by Gabriel Muelas on 13/07/22.
//

import SwiftUI

struct AddFavorites: View {
    @ObservedObject var treeViewModel: TreeViewModel
    
    @Binding var showAddFavoritesSheet: Bool
    
    private func treeRow(tree: TreeFB) -> some View {
        HStack {
            Image("treeExample")
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(tree.name)
                    .font(.headline)
                
                Text("cidade universadjnasodmsalmas")
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
            }
            
            
            Spacer()
            
            Button(action: {
                treeViewModel.addToFavorites(tree: tree)
                showAddFavoritesSheet.toggle()
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.orange)
            }
        }
    }
    
    private var unfavorites: [TreeFB] {
        treeViewModel.store.filter { tree in
            !treeViewModel.favorites.contains { $0.id == tree.id }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(unfavorites) { tree in
                    treeRow(tree: tree)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Adicionar aos favoritos")
            .toolbar {
                Button(action: {
                    showAddFavoritesSheet.toggle()
                }) {
                    Text("OK")
                        .fontWeight(.semibold)
                }
                .tint(.orange)
            }
        }
    }
}
