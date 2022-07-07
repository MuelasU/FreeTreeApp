//
//  TreeRegistrationView.swift
//  FreeTreeApp
//
//  Created by Caroline Andreoni Barcat Intaschi on 05/07/22.
//

import Foundation
import SwiftUI

struct TreeRegistrationView: View {
    weak var navigationController: UINavigationController?
    @State private var treeName: String = ""
    @State private var tags: [String] = [""]
    @State private var complement: String = ""
    @State private var numberOfTags: Int = 0
    
    var body: some View {
        NavigationView {
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
                Section(header: Text("Complemento")) {
                    TextEditor(text: $complement)
                        .frame(height: 100)
                }
            }
        }
        .navigationTitle("Cadastro")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Salvar") {
                    let tree = Tree(name: treeName, date: .now, tag: tags, advices: [])
                    let treeService = TreeServices()
                    
                    treeService.create(tree: tree) { error in
                        if let error = error {
                            print("Não foi possível criar a árvore \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        
    }
}
