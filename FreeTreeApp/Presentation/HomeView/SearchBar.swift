//
//  SearchBar.swift
//  FavPlaces
//
//  Created by Cesar Augusto Barros on 03/07/22.
//

import SwiftUI

struct SearchBar: View {
    weak var navigationController: UINavigationController?
    @State var searchText: String = ""
    @State var index: Int = 0
    @State var typing: Bool = false
    @Binding var searchingFor: String
    
    let profilePic: String
    
    init (
        profilePic: String,
        searchingFor: Binding<String>
    ) {
        self.profilePic = profilePic
        self._searchingFor = searchingFor
    }
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 8)
                    TextField(Constants.textFieldPrompt, text: $searchingFor)
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                    Image(systemName: "mic")
                        .padding(.trailing, 8)
                }
            }
            .frame(height: 36, alignment: .top)
            .cornerRadius(13)
            .padding(8)
            Image(profilePic)
                .resizable()
                .frame(width: 45, height: 45)
                .padding(8)
        }
    }
}

extension SearchBar {
    struct Constants {
        // static let white: Color = Color(uiColor: .init(red: 227/255, green: 227/255, blue: 233/255, alpha: 1))
        static let textFieldPrompt: String = "Buscar árvores"
    }
}
#if DEBUG
struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(profilePic: "profilePic", searchingFor: .constant("Limoeiro"))
    }
}
#endif
