//
//  ActivityIndicator.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/16/20.
//

import Foundation
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    let color: UIColor
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIViewType {
        let view = UIActivityIndicatorView(style: self.style)
        view.color = self.color
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
