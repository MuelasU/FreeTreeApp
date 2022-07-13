//
//  FavoriteList.swift
//  FavPlaces
//
//  Created by Cesar Augusto Barros on 03/07/22.
//

import SwiftUI

struct FavoriteList: View {
    weak var navigationController: UINavigationController?
    let allTrees: [TreeFB]
    
    init (
        allTrees: [TreeFB]
    ) {
        self.allTrees = allTrees
    }

    func cellFor(tree: TreeFB) -> some View {
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
                ForEach(allTrees.prefix(3)) { tree in
                    cellFor(tree: tree)
                }
                
                Button(action: {}) {
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

extension FavoriteList {
    struct Constants {
        static let white: Color = Color(uiColor: .init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.9))
    }
}

struct FavoriteList_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteList(allTrees: .init())
    }
}
