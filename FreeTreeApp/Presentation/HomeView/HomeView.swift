//
//  SearchView.swift
//  FreeTreeApp
//
//  Created by Cesar Augusto Barros on 02/07/22.
//

import SwiftUI

struct HomeView: View {
    weak var navigationController: UINavigationController?
    @ObservedObject var viewModel: ViewModel
    @State private var searchingFor: String = ""

    var body: some View {
        SearchBar(profilePic: viewModel.profilePic, searchingFor: self.$searchingFor)
        if searchingFor.isEmpty {
            ScrollView {
//                FavoriteList(allTrees: viewModel.allTrees)
                RecentList(allTrees: viewModel.allTrees ?? [])
            }
        } else {
            SearchResultList(trees: viewModel.allTrees ?? [], searchingFor: self.$searchingFor)
        VStack {
            SearchBar(profilePic: viewModel.profilePic)
            ScrollView {
                FavoriteList(allTrees: viewModel.allTrees)
                RecentList(allTrees: viewModel.allTrees)
            }
        }
        Button("Pega as arvores") {
            viewModel.getTrees(completion: { trees in
                    print("Botão pega as arvores")
                  })
        }
    }
}

extension HomeView {
    class ViewModel: ObservableObject {
        var profilePic: String = "profilePic"
        var allTrees:[Tree]? {
            didSet {
                print("allTrees is on, baby 😎")
            }
        }

        public func getTrees(completion: ([Tree]) -> Void) {
            let treeServices = TreeServices()
            treeServices.read { result in
                switch result {
                case let .success(trees):
                    self.allTrees = trees
                case let .failure(error):
                    print("Não foi possível ler as árvores do banco \(error.localizedDescription)")
                }
            }
        }
    }
}
