//
//  RecentList.swift
//  FavPlaces
//
//  Created by Cesar Augusto Barros on 04/07/22.
//

import SwiftUI

struct RecentList: View {
    weak var navigationController: UINavigationController?

    let allTrees: [Tree]

    init ( allTrees: [Tree]) {
        self.allTrees = allTrees
    }

    var body: some View {
        Text("Recentes")
            .bold()
            .font(.system(size: 15))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.gray)
            .padding([.leading], 9)
        ScrollView {
            ForEach(allTrees.prefix(3)) { tree in
                HStack {
                    //TODO: recebe uma UIImage, muda a Tree ou pensa em outra saída?
                    Image("treeExample")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(100)
                    VStack {
                        Text(tree.name)
                            .font(.system(size: 17))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading], 9)
                        Text(tree.name)
                            .font(.system(size: 11))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading], 9)
                            .foregroundColor(.gray)
                    }
                } .frame(height: 55, alignment: .center)
        }.padding([.leading], 17)
            .cornerRadius(10)
            .background(Constants.white)
        }
    }
}

extension RecentList {
    struct Constants {
        static let white: Color = Color(uiColor: .init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
    }
}

#if DEBUG
struct RecentList_Previews: PreviewProvider {
    static var previews: some View {
        RecentList(allTrees: .init())
    }
}
#endif
