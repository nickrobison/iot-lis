//
//  FullscreenButton.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import SwiftUI

struct FullscreenButton: View {
    let text: String
    @Binding var isAnimating: Bool
    let handler: (() -> Void)
    var body: some View {
        Button(action: self.handler) {
            HStack {
                Text(self.text)
                    .fontWeight(.semibold)
                    .font(.title)
                ActivityIndicator(isAnimating: self.$isAnimating, style: .large, color: .white)
            }
            .padding()
            .foregroundColor(Color.white)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.accentColor)
            .cornerRadius(40)
//            .padding()
        }
    }
}

struct FullscreenButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FullscreenButton(text: "Load Data", isAnimating: .constant(false), handler: ({
                // Nothing
            }))
            FullscreenButton(text: "Load Data", isAnimating: .constant(true), handler: ({
                // Nothing
            }))
        }
    }
}
