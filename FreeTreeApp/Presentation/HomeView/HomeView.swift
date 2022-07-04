//
//  SearchView.swift
//  FreeTreeApp
//
//  Created by Cesar Augusto Barros on 02/07/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var searchTexts: String = ""
    @State var index: Int = 0

    var body: some View {
        SearchBar(profilePic: viewModel.profilePic)
        ScrollView {
                FavoriteList(allTrees: viewModel.allTrees)
                RecentList(allTrees: viewModel.allTrees)
        }
    }
}

struct CardView: View {
    var body: some View {
        Rectangle()
            .fill(Color.orange)
            .frame(height: 114)
            .border(Color.black)
            .padding()
    }
}

extension HomeView {
    class ViewModel: ObservableObject {
        @Published var textFieldPrompt: String = "Buscar árvores"
        @Published var leadingPadding: CGFloat = 8
        @Published var profilePic: String = "profilePic"
        @Published var treeName: String = ""
        @Published var treeLocal: String = ""
        @Published var treePic: Image = .init(systemName: "leaf")
        @Published var isFavorite: Bool = true

        @Published var allTrees: [[String]] = [
            ["Plantinha", "Instituto de pesquisas Eldorado", "treeExample", "yes"],
            ["Limoeiro", "Praça do limão", "treeExample", "no"],
            ["Pé de morango", "Praça do morango", "treeExample", "yes"]
        ]

        public func getFavorites() {
            for(tree, item) in allTrees.enumerated() {
                for caracteristcs in item {
                    print("index : \(tree) item: \(caracteristcs)")
                }
            }
        }
    }
}

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}
#endif
