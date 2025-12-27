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
    let square: Square

    var action: () -> Void

    var body: some View {
        Button(action: {
            self.action()
        }, label: {
            Text(textForStatus(square.squareStatus))
                .font(.system(size: 60))
                .bold()
                .foregroundStyle(colorForStatus(square.squareStatus))
                .frame(width: 90, height: 90, alignment: .center)
                .background(backgroundColor.clipShape(.rect(cornerRadius: 10)))
                .padding(4)
        })
    }

    func textForStatus(_ status: SquareStatus) -> String {
        switch status {
        case .x, .xw: return "X"
        case .o, .ow: return "O"
        default: return " "
        }
    }

    func colorForStatus(_ status: SquareStatus) -> Color {
        if status == .xw || status == .ow {
            return Color.green.opacity(0.9)
        }
        return colorScheme == .dark ? Color.white.opacity(0.9) : Color.black.opacity(0.9)
    }

    var backgroundColor: Color {
        return colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.3)
    }
}

#Preview {
    SquareView(square: Square(status: .x), action: {})
            .preferredColorScheme(.dark)
}
