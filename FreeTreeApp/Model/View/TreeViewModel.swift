//
//  TreeViewModel.swift
//  FreeTreeApp
//
//  Created by Gabriel Muelas on 13/07/22.
//

import Foundation

class TreeViewModel: ObservableObject {
    @Published var store: [TreeFB] = [] {
        didSet {
            //Update published
            favorites = favoritesTrees
        }
    }
    @Published var favorites: [TreeFB] = []
    
    func addToFavorites(tree: TreeFB) {
        if var favorites =  favoritesId {
            favorites.append(tree.id!)
            //Update user defaults
            Configuration.user.set(favorites, forKey: Configuration.favoritesKey)
        } else {
            Configuration.user.set([tree.id!], forKey: Configuration.favoritesKey)
        }
        //Update published
        self.favorites = favoritesTrees
    }
    
    //TODO: Test it
    func removeFromFavorites(tree: TreeFB) {
        if
            var userFavorites = favoritesId,
            let idx = userFavorites.firstIndex(of: tree.id!)
        {
            //Remove on published
            favorites.removeAll { $0.id == tree.id }
            
            //Remove on user
            userFavorites.remove(at: idx)
            Configuration.user.set(userFavorites, forKey: Configuration.favoritesKey)
        }
    }
    
    struct Configuration {
        static let favoritesKey = "favorites"
        static let user = UserDefaults.standard
    }
    
    private var favoritesId: [String]? {
        Configuration.user.array(forKey: Configuration.favoritesKey) as? [String]
    }
    
    private var favoritesTrees: [TreeFB] {
        guard let favoritesId = favoritesId else {
            return []
        }

        return store.filter { favoritesId.contains($0.id!) }
    }
}
