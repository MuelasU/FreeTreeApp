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
    
    func rowFor(tree: Tree) -> some View {
        HStack {
            Image("treeExample")
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack {
                Text(tree.name)
                    .font(.headline)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                //TODO: Change for adress string
                Text(tree.name)
                    .font(.caption)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
            }
        }
    }

    var body: some View {
        List {
            ForEach(allTrees.prefix(3)) { tree in
                rowFor(tree: tree)
            }
        }
        .onAppear(perform: {
                UITableView.appearance().contentInset.top = -35
                UITableView.appearance().isScrollEnabled = false
        })
    }
}

#if DEBUG
struct RecentList_Previews: PreviewProvider {
    static var previews: some View {
        RecentList(allTrees: .init())
    }
}
#endif
