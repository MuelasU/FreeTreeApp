//
//  FavoriteList.swift
//  FavPlaces
//
//  Created by Cesar Augusto Barros on 03/07/22.
//

import SwiftUI

struct FavoriteList: View {
    weak var navigationController: UINavigationController?
    let allTrees: [Tree]
    
    init (
        allTrees: [Tree]
    ) {
        self.allTrees = allTrees
    }
    
    var body: some View {
        Text("Árvores favoritas")
            .bold()
            .font(.system(size: 15))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.gray)
            .padding([.leading], 9)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(allTrees.prefix(3)) { tree in
                    ZStack {
                        VStack {
                            Image("treeExample")
                                .resizable()
                                .scaledToFill()
                            Text(tree.name)
                                .font(.system(size: 12))
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading], 9)
                        }
                    }
                    .background(Constants.white)
                    .frame(width: 115, height: 115, alignment: .bottom)
                    .cornerRadius(10)
                }
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray)
                    VStack {
                        Image(systemName: "plus")
                        Text("Adicionar")
                            .font(.system(size: 11))
                    }
                }
                .frame(width: 115, height: 115, alignment: .top)
                .cornerRadius(10)
            }
        }.padding([.leading], 17)
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
