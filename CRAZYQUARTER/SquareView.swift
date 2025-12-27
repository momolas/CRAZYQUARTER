//
//  SquareView.swift
//  TicTacToe
//
//  Created by null on 05/09/2023.
//

import Foundation
import SwiftUI

struct SquareView : View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var square: Square
    
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }, label: {
//            Text(square.squareStatus == .empty ? " " : square.squareStatus == .x || square.squareStatus == .xw ? "X" : "O")
            Text(square.squareStatus == .x || square.squareStatus == .xw ? "X" : square.squareStatus == .o || square.squareStatus == .ow ? "O" : " ")
                .font(.system(size: 60))
                .bold()
                .foregroundColor(square.squareStatus == .xw || square.squareStatus == .ow ? (Color.green.opacity(0.9)) : (colorScheme == .dark ? Color.white.opacity(0.9) : Color.black.opacity(0.9)))
                .frame(width: 90, height: 90, alignment: .center)
                .background(colorScheme == .dark ? Color.white.opacity(0.3).cornerRadius(10) : Color.gray.opacity(0.3).cornerRadius(10))
                .padding(4)
        })
    }
}

#Preview {
    SquareView(square: Square(status: .x), action: {})
            .preferredColorScheme(.dark)
}
