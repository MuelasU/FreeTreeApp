//
//  FavoriteList.swift
//  FavPlaces
//
//  Created by Cesar Augusto Barros on 03/07/22.
//

import SwiftUI

struct FavoriteList: View {
    weak var navigationController: UINavigationController?
    let allTrees: [[String]]

    init (
        allTrees: [[String]]
    ) {
        self.allTrees = allTrees
    }

    func cellFor(index: Int) -> some View {
        return ZStack(alignment: .bottom) {
            Image(allTrees[index][2])
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
            
            Text(allTrees[index][0])
                .font(.subheadline)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.regularMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<allTrees.count, id: \.self) { index in
                    cellFor(index: index)
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
