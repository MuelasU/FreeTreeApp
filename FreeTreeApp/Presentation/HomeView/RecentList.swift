//
//  RecentList.swift
//  FavPlaces
//
//  Created by Cesar Augusto Barros on 04/07/22.
//

import SwiftUI

struct RecentList: View {
    let allTrees: [[String]]

    init ( allTrees: [[String]]) {
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
            ForEach(0..<allTrees.count, id: \.self) { index in
                HStack {
                    Image(allTrees[index][2])
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(100)
                    VStack {
                        Text(allTrees[index][0])
                            .font(.system(size: 17))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading], 9)
                        Text(allTrees[index][1])
                            .font(.system(size: 11))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading], 9)
                            .foregroundColor(.gray)
                    }
                } .frame(height: 55, alignment: .center)
            }
        }.padding([.leading], 17)
            .cornerRadius(10)
            .background(Constants.white)
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
