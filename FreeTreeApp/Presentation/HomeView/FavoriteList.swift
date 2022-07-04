//
//  FavoriteList.swift
//  FavPlaces
//
//  Created by Cesar Augusto Barros on 03/07/22.
//

import SwiftUI

struct FavoriteList: View {
    let allTrees: [[String]]

    init (
        allTrees: [[String]]
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
        ScrollView(.horizontal) {
            HStack {
                ForEach(0...allTrees.count, id: \.self) { index in
                    if index < allTrees.count {
                        if allTrees[index][3] == "yes"{
                            ZStack {
                                VStack {
                                    Image(allTrees[index][2])
                                        .resizable()
                                        .scaledToFill()
                                    Text(allTrees[index][0])
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
                    } else {
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
                }
            }
        } .padding([.leading], 17)
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
