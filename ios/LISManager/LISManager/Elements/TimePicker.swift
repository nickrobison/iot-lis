//
//  TimePicker.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/27/20.
//

import Foundation
import SwiftUI
import UIKit

struct TimePicker: UIViewRepresentable {
    typealias UIViewType = UIDatePicker
    
    @Binding var date: Date
    
    private let datePicker = UIDatePicker()
    
    func makeUIView(context: Context) -> UIDatePicker {
        self.datePicker.datePickerMode = .countDownTimer
        self.datePicker.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
        return datePicker
    }
    
    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        datePicker.date = self.date
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(date: self.$date)
    }
    
    class Coordinator: NSObject {
        private let date: Binding<Date>
        
        init(date: Binding<Date>) {
            self.date = date
        }
        
        @objc func changed(_ sender: UIDatePicker) {
            self.date.wrappedValue = sender.date
        }
    }
    
}
