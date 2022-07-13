//
//  FavoriteList.swift
//  FavPlaces
//
//  Created by Cesar Augusto Barros on 03/07/22.
//

import SwiftUI

struct FavoriteList: View {
    weak var navigationController: UINavigationController?
    
    @ObservedObject var treeViewModel: TreeViewModel

    func cellFor(tree: Tree) -> some View {
        return ZStack(alignment: .bottom) {
            Image("treeExample")
                .resizable()
                .scaledToFill()
                
            Text(tree.name)
                .font(.subheadline)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.top, 5)
                .padding(.bottom, 10)
                .background(.regularMaterial)
        }
        .frame(width: 120, height: 120)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(treeViewModel.favorites) { tree in
                    cellFor(tree: tree)
                }
                
                Button(action: {
                    
                    //TODO: Present add to favorites sheet
                    
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.largeTitle.weight(.semibold))
                        
                        Text("Adicionar")
                            .font(.subheadline.weight(.semibold))
                    }
                    .foregroundColor(.orange)
                    .frame(width: 120, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
