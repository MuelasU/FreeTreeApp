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
    
    private func sectionTitle(_ title: String) -> some View {
        return Text(title)
            .font(.headline.weight(.semibold))
            .foregroundColor(Color(uiColor: .secondaryLabel))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
    }
    
    var body: some View {
        VStack {
            SearchBar(profilePic: viewModel.profilePic, searchingFor: self.$searchingFor)
            
            if searchingFor.isEmpty {
                VStack {
                    sectionTitle("Árvores favoritas")
                    FavoriteList(allTrees: allTrees)
                    
                    Spacer(minLength: 20)
                    
                    sectionTitle("Recentes")
                    RecentList(allTrees: allTrees)
                }
            } else {
                SearchResultList(trees: allTrees, searchingFor: self.$searchingFor)
            }
        }
    }
}

extension HomeView {
    class ViewModel: ObservableObject {
        var profilePic: String = "profilePic"
        
    }
}
