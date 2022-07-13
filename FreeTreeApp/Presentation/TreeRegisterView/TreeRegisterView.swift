//
//  TreeRegisterView.swift
//  FreeTreeApp
//
//  Created by Caroline Andreoni Barcat Intaschi on 08/07/22.
//

import Foundation
import SwiftUI

class TreeRegisterViewModel: ObservableObject {
    var closeAction: () -> Void = {}
}

struct TreeRegistrationView: View {
    weak var navigationController: UINavigationController?
    var TreeRegisterVM: TreeRegisterViewModel
    
    @State var lat: Double
    @State var long: Double
    @State var userAdress: String
    
    @State private var treeName: String = ""
    @State private var presentAlert: Bool = false
    @State private var tags: [String] = [""]
    @State private var complement: String = ""
    @State private var numberOfTags: Int = 0
    
    @State private var showingImagePicker = false
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                HStack {
                    Button("Cancelar") {
                        self.TreeRegisterVM.closeAction()
                    }.padding(.leading, 16)
                    
                    Spacer()
                    
                    Text("Cadastrar")
                        .bold()
                    
                    Spacer()
                    
                    Button("Salvar") {
                        var tree = TreeFB(name: treeName, date: .now, tag: tags, advices: [])
                        
                        // save current user location in Tree object
                        let coordinate = Location(lat: lat, lgt: long)
                        tree.coordinates = coordinate
                        let treeService = TreeServices()
                        
                        // create new tree
                        treeService.create(tree: tree, treeImages: []) { error in
                            if let error = error {
                                print("Não foi possível criar a árvore \(error.localizedDescription)")
                                self.presentAlert = false
                            }
                        }
                        
                        // close modalView after click saving
                        self.TreeRegisterVM.closeAction()
                    }
                    .padding(.trailing, 16)
                    .disabled(treeName.isEmpty)
                }.padding(.top, 16)
                
                Form {
                    Section {
                        TextField("Name", text: $treeName)
                            .frame(height: 44)
                            .background(Color.white)
                    }
                    Section {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                            Button("Adicionar Tag") {
                                tags.append("")
                                numberOfTags += 1
                                print(numberOfTags)
                            }
                        }
                        ForEach((0...numberOfTags), id: \.self) { tag in
                            TextField("Tag name", text: $tags[tag])
                                .frame(height: 44)
                                .background(Color.white)
                        }
                    }
                    Section(header: Text("Your Current Location")) {
                        Text(userAdress)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.gray)
                    }
                    Section(header: Text("Complemento")) {
                        TextEditor(text: $complement)
                            .frame(height: 100)
                    }
                }
            }
        }
    }
}
