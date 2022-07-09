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
    var allTrees: [Tree]
    
    var body: some View {
        SearchBar(profilePic: viewModel.profilePic, searchingFor: self.$searchingFor)
            if searchingFor.isEmpty {
                FavoriteList(allTrees: allTrees)
                RecentList(allTrees: allTrees)
            } else {
                SearchResultList(trees: allTrees, searchingFor: self.$searchingFor)
            }
    }
}

extension HomeView {
    class ViewModel: ObservableObject {
        var profilePic: String = "profilePic"
        
    }
}
