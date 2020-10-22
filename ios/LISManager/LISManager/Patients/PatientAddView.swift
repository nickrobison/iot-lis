//
//  PatientAddView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import SwiftUI

struct PatientAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var model = PatientAddModel()
    
    private let now = Date()
    
    var completionHandler: ((PatientModel) -> Void)?
    //    private let minDate = Calendar.current.date(byAdding: .year, value: -65, to: Date())!
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: self.$model.firstName)
                    TextField("Last Name", text: self.$model.lastName)
                }
                Section(header: Text("Demographics")) {
                    HStack {
                        TextField("Gender", text: self.$model.gender)
                        TextField("Sex", text: self.$model.sex)
                    }
                    HStack {
                        DatePicker(selection: self.$model.birthday, in: ...self.now, displayedComponents: .date, label: {
                            EmptyView()
                        })
                        Spacer()
//                        Text("Age")
                    }
                }
                Section(header: Text("Address")) {
                    TextField("Address", text: self.$model.address1)
                    TextField("Line 2", text: self.$model.address2)
                    HStack {
                        TextField("City", text: self.$model.city)
                        TextField("State", text: self.$model.state)
                        TextField("Zip", text: self.$model.zipCode)
                    }
                }
            }
            .navigationBarTitle(Text("Add Patient"))
            .navigationBarItems(leading: Button(action: {
                debugPrint("Cancel")
                self.presentationMode.wrappedValue.dismiss()
            }, label: {Text("Cancel")}), trailing:
                Button(action: {
                    self.create()
                }, label: { Text("Add")})
                .disabled(!self.model.isValid))
        }
    }
    
    private func create() {
        self.completionHandler?(self.model.toModel())
        self.presentationMode.wrappedValue.dismiss();
    }
}

struct PatientAddView_Previews: PreviewProvider {
    static var previews: some View {
        PatientAddView()
    }
}
