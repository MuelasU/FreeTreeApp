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
//                RecentList(allTrees: viewModel.allTrees)
            }
        } else {
            SearchResultList(trees: treeNames, searchingFor: self.$searchingFor)
        }
        Button("Pega as arvores") {
            viewModel.getTrees(completion: { trees in
                    print(trees)
                  })
        }
    }

    var treeNames: [String] {
        var namesOnly: [String] = []
        for name in viewModel.allTrees! {
            namesOnly.append(name.name)
        }
        return namesOnly
    }
}

extension HomeView {
    class ViewModel: ObservableObject {
        
        var textFieldPrompt: String = "Buscar árvores"
        var leadingPadding: CGFloat = 8
        var profilePic: String = "profilePic"
        var completion = ((Float) -> Void)?.self
        var allTrees:[Tree]? {
            didSet {
                print("Arvores carregadas do servidor")
            }
        }
        
        var treeName: String = ""
        var treeLocal: String = ""
        var treePic: Image = .init(systemName: "leaf")
        var isFavorite: Bool = true
        

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
        
        public func printTrees() {
            allTrees?.forEach() {
                print("*_*_*_*_*_*_*_*_*_*_*_*_*")
                print($0)
            }
        }
        
//        var allTrees: [[String]] = [
//            ["Plantinha", "Instituto de pesquisas Eldorado", "treeExample", "yes"],
//            ["Limoeiro", "Praça do limão", "treeExample", "no"],
//            ["Pé de morango", "Praça do morango", "treeExample", "yes"]
//        ]
    }
}

//#if DEBUG
//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(viewModel: .init())
//    }
//}
//#endif
