//
//  SquareView.swift
//  CRAZYQUARTER
//
//  Created by null on 05/09/2023.
//

import SwiftUI

struct SquareView: View {
    @Environment(\.colorScheme) private var colorScheme
    let square: Square
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(textForStatus(square.status))
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .foregroundStyle(colorForStatus(square.status))
                .frame(width: 90, height: 90)
                .background(backgroundColor.clipShape(.rect(cornerRadius: 12)))
                .padding(4)
        }
        .accessibilityLabel(accessibilityLabel(for: square.status))
    }
    
    private func textForStatus(_ status: SquareStatus) -> String {
        switch status {
        case .x, .xw: "X"
        case .o, .ow: "O"
        default: " "
        }
    }
    
    private func accessibilityLabel(for status: SquareStatus) -> String {
        switch status {
        case .x: "Case X"
        case .o: "Case O"
        case .xw: "Case X gagnant"
        case .ow: "Case O gagnant"
        case .empty: "Case vide"
        }
    }
    
    private func colorForStatus(_ status: SquareStatus) -> Color {
        if status == .xw || status == .ow {
            return .green
        }
        return .primary
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.15) : Color.gray.opacity(0.15)
    }
}

#Preview {
    SquareView(square: Square(id: 0, status: .x), action: {})
        .preferredColorScheme(.dark)
}
