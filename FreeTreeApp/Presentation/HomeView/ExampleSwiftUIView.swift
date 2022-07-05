//
//  ExampleSwiftUIView.swift
//  FreeTreeApp
//
//  Created by Cesar Augusto Barros on 04/07/22.
//

import SwiftUI

struct ExampleSwiftUIView: View {
    // "Simula" a ViewController
    weak var navigationController: UINavigationController?

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ExampleSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleSwiftUIView()
    }
}
