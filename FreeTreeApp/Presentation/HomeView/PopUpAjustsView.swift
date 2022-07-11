//
//  PopUpAjustsView.swift
//  FreeTreeApp
//
//  Created by Pedro Haruke Leme da Rocha Rinzo on 05/07/22.
//

import SwiftUI

struct PopUpAjustsView: View {
    weak var navigationController: UINavigationController?
    var ajusts: [Ajusts] = AjustList.ajusts
    
    let didClose: () -> Void
    
    var body: some View {
        VStack (spacing: 0){
            header
            ajustList
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(RoundedCorners(color: Constants.grayBackground, tl: 10, tr: 10, bl: 0, br: 0))
        .transition(.move(edge: .bottom))
    }
}

struct PopUpAjustsView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpAjustsView {}
            .previewLayout(.sizeThatFits)
    }
}

private extension PopUpAjustsView {
    
    struct Constants {
        static let grayBackground: Color = Color(uiColor: .init(red: 242/255, green: 242/255, blue: 247/255, alpha: 1))
    }
    
    var header: some View {
        HStack {
            Image("profilePic")
                .resizable()
                .frame(width: 45, height: 45)
                .padding(8)
            VStack(alignment: .leading) {
                Text("User Name")
                    .bold()
                    .font(.system(size: 24))
                Text("usermail@freetree.com")
                    .tint(.gray)
                    .font(.system(size: 22))
            }
            Button {
                didClose()
            } label: {
                Image(systemName: "xmark")
                    .symbolVariant(.circle.fill)
                    .font(.system(size: 30,
                                  weight: .bold,
                                  design: .rounded))
            }
            .padding(.bottom, 25)
            .foregroundColor(.gray)
        }
    }
    
    var ajustList: some View {
        List(ajusts, id: \.id) { ajust in
            Button  {
                //add
            } label: {
                HStack (spacing: 15) {
                    Image(ajust.iconName)
                        .resizable()
                    .frame(width: 35, height: 35)
                    Text(ajust.descriptionAjust)
                        .font(.system(size: 17))
                }
            }
        }
        .cornerRadius(20)
        .frame(maxHeight: 205)
        .padding(.init(top: 5, leading: 20, bottom: 0, trailing: 20))
        .listStyle(.plain)
    }
}

