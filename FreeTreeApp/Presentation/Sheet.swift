//
//  Sheet.swift
//  FreeTreeApp
//
//  Created by Gabriel Muelas on 29/06/22.
//

import SwiftUI

protocol SheetDelegate: AnyObject {
    func didChangeHeight(to newHeight: SheetHeight)
//    func isChangingHeight(by offset: CGFloat)
}

enum SheetHeight {
    case bottom
    case short
    case tall

    private var sheetHeaderHeight: CGFloat { 200 }

    var offset: CGFloat {
        switch self {
        case .bottom:
            return UIScreen.main.bounds.height - sheetHeaderHeight
        case .short:
            return UIScreen.main.bounds.height/2 + 60
        case .tall:
            return 200
        }
    }
}

struct Sheet<Content: View>: View {

    weak var delegate: SheetDelegate?

    @State var height: SheetHeight {
        didSet {
            delegate?.didChangeHeight(to: height)
        }
    }

    @ViewBuilder let content: () -> Content
    @State private var translation: CGSize = .zero
//    @State private var offsetY: CGFloat = 0

    private var animation: Animation {
        .interactiveSpring(response: 0.5, dampingFraction: 1)
    }

    private var grabber: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.secondary)
            .frame(width: 40, height: 5)
            .padding(8)
            .onTapGesture {
                withAnimation(animation) {
                    switch height {
                    case .bottom:
                        height = .short
                    case .short:
                        height = .tall
                    case .tall:
                        height = .bottom
                    }
                }
            }
    }

    var body: some View {
        VStack {
            grabber
                .frame(maxWidth: .infinity, alignment: .center)
            content()
        }
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(20)
//        .offset(y: translation.height + height.offset)
        .offset(y: translation.height)
        .gesture(
            DragGesture()
                .onChanged { value in
//                    let diff: CGFloat = (value.location.y - value.startLocation.y)
//
//                    if height == .tall && diff < 0 {
//                        return
//                    }

                    translation = value.translation
//                    delegate?.isChangingHeight(by: translation.height)
                }
                .onEnded { _ in
                    withAnimation(animation) {
                        let snap = translation.height + height.offset

                        if snap > 500 {
                            height = .bottom
                        } else if snap > 300 {
                            height = .short
                        } else {
                            height = .tall
                        }

                        translation = .zero
                    }
                }
        )
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct Sheet_Previews: PreviewProvider {

    static var previews: some View {
        Sheet(height: .tall) {
            VStack {
                Button(action: { print("teste") }) {
                    Text("ASDASDASD")
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
        }
    }
}
