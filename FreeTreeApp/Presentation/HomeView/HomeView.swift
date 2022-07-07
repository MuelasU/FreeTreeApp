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
    @State private var searchTexts: String = ""
    @State var index: Int = 0
    @EnvironmentObject var sheetManager: SheetManager
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel;
    }
    
    var body: some View {
        VStack {
            SearchBar(profilePic: viewModel.profilePic)
            ScrollView {
                FavoriteList(allTrees: viewModel.allTrees)
                RecentList(allTrees: viewModel.allTrees)
            }
        }
        .overlay(alignment: .bottom) {
            if sheetManager.action.isPresented {
                PopUpAjustsView {
                    withAnimation {
                        sheetManager.dismiss()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

extension HomeView {
    class ViewModel: ObservableObject {
        var textFieldPrompt: String = "Buscar árvores"
        var leadingPadding: CGFloat = 8
        var profilePic: String = "profilePic"
        var treeName: String = ""
        var treeLocal: String = ""
        var treePic: Image = .init(systemName: "leaf")
        var isFavorite: Bool = true

        var allTrees: [[String]] = [
            ["Plantinha", "Instituto de pesquisas Eldorado", "treeExample", "yes"],
            ["Limoeiro", "Praça do limão", "treeExample", "no"],
            ["Pé de morango", "Praça do morango", "treeExample", "yes"]
        ]
    }
}

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
            .environmentObject(SheetManager())
    }
}
#endif
