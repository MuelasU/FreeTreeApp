//
//  Ajusts.swift
//  FreeTreeApp
//
//  Created by Pedro Haruke Leme da Rocha Rinzo on 06/07/22.
//

import SwiftUI

struct Ajusts: Identifiable {
    var id = UUID()
    let iconName: String
    let descriptionAjust: String
}

struct AjustList {
    static let ajusts = [
        Ajusts(iconName: "treeIcon",
               descriptionAjust: "Árvores registradas"),
        
        Ajusts(iconName: "registerRecipesIcon",
               descriptionAjust: "Receitas registradas"),
        
        Ajusts(iconName: "changeAvatarIcon",
               descriptionAjust: "Alterar avatar"),
        
        Ajusts(iconName: "notifyIcon",
               descriptionAjust: "Notificações"),
    ]
}
