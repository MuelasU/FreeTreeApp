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
    @State private var treeName: String = "Name"
    @State private var complement: String = "Complemento"

        var body: some View {
            NavigationView {
                VStack(alignment: .leading) {
                    TextField("Name", text: $treeName)
                    Text("Hello, \(treeName)!")
                    
                    TextEditor(text: $complement)
                }
            }
            .navigationTitle("Cadastro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar") {
                        print("Salvar tapped!")
                    }
                }
            }
            
        }
}
