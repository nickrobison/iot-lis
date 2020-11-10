//
//  ResultCardView.swift
//  LISManager
//
//  Created by Nick Robison on 11/10/20.
//

import SwiftUI

struct ResultCardView: View {
    
    @State private var positive = false
    @State private var testType = "Binax"
    
    var sampleType: String
    
    var body: some View {
        VStack {
            HStack {
                Image(sampleType)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
                Spacer()
                Text("\(testType) Sample").font(.headline)
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
        .frame(width: nil, height: 230)
        .background(Color.white)
        .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 4))
    }
}

struct ResultCardView_Previews: PreviewProvider {
    static var previews: some View {
        ResultCardView(sampleType: "binax")
    }
}
