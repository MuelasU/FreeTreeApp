//
//  Sheet.swift
//  FreeTreeApp
//
//  Created by Gabriel Muelas on 29/06/22.
//

import SwiftUI

protocol SheetDelegate: AnyObject {
    func didChangeHeight(to newHeight: SheetHeight)
    func didStartDragGesture()
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
            return 60
        }
    }
}

struct Sheet<Content: View>: View {

    weak var delegate: SheetDelegate?
    
    @EnvironmentObject var sheetManager: SheetManager

    @State var height: SheetHeight
    @ViewBuilder let content: () -> Content
    
    @State private var translation: CGSize = .zero
    @State private var offsetY: CGFloat = .zero
    @State private var isAnimating: Bool = false
    @State private var isDragging: Bool = false {
        didSet {
            if isDragging {
                delegate?.didStartDragGesture()
            }
        }
    }

    private var animation: Animation {
        .interactiveSpring(response: 0.5, dampingFraction: 1)
    }

    private var grabber: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.secondary)
            .frame(width: 40, height: 5)
            .padding(8)
            .onTapGesture {
                isAnimating = true
                withAnimation(animation) {
                    let initialOffset = height.offset
                    
                    switch height {
                    case .bottom:
                        height = .short
                    case .short:
                        height = .tall
                    case .tall:
                        height = .bottom
                    }

                    offsetY = height.offset - initialOffset
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
        .offset(y: offsetY)
        .onAnimationCompleted(for: offsetY) {
            delegate?.didChangeHeight(to: height)
            offsetY = .zero
            isAnimating = false
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !isDragging {
                        isDragging = true
                    }
                    translation = value.translation
                    offsetY = translation.height
                }
                .onEnded { _ in
                    isDragging = false
                    isAnimating = true
                    withAnimation(animation) {
                        let initialOffset = height.offset
                        let snap = translation.height + initialOffset

                        if snap > 500 {
                            height = .bottom
                        } else if snap > 300 {
                            height = .short
                        } else {
                            height = .tall
                        }
                        
                        offsetY = height.offset - initialOffset
                        translation = .zero
                    }
                }
        )
        .allowsHitTesting(!isAnimating)
        .edgesIgnoringSafeArea(.all)
    }
}
