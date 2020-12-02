//
//  ResultCardView.swift
//  LISManager
//
//  Created by Nick Robison on 11/10/20.
//

import SwiftUI

struct ResultCardView: View {
    
    @State private var positive = false
    @State var testType: String
    
    var body: some View {
        VStack {
            HStack {
                Image(testType)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
                Spacer()
                Text("\(testType.capitalizingFirstLetter()) Sample").font(.headline)
                Spacer()
            }
            HStack {
                Text("Sample type:")
                Spacer()
                TextField("", text: $testType)
                    .foregroundColor(.gray)
                    .frame(width: 50, height: nil)
            }
            Toggle("Test Positive?", isOn: $positive)
            Button("Submit") {
                debugPrint("Submitting")
            }
        }
        .frame(width: 300, height: 230)
        .padding([.leading, .trailing])
        .background(Color.white)
        .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 4))
    }
}

struct ResultCardView_Previews: PreviewProvider {
    static var previews: some View {
        ResultCardView(testType: "binax")
    }
}
