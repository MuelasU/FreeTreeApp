//
//  RecentList.swift
//  FavPlaces
//
//  Created by Cesar Augusto Barros on 04/07/22.
//

import SwiftUI

struct RecentList: View {
    weak var navigationController: UINavigationController?

    let allTrees: [[String]]

    init ( allTrees: [[String]]) {
        self.allTrees = allTrees
    }
    
    func rowFor(index: Int) -> some View {
        HStack {
            Image(allTrees[index][2])
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack {
                Text(allTrees[index][0])
                    .font(.headline)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(allTrees[index][1])
                    .font(.caption)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
            }
        }
    }

    var body: some View {
        List {
            ForEach(0..<allTrees.count, id: \.self) { index in
                rowFor(index: index)
            }
        }
        .onAppear(perform: {
                UITableView.appearance().contentInset.top = -35
                UITableView.appearance().isScrollEnabled = false
        })
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
