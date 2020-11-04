//
//  UserLoginView.swift
//  LISManager
//
//  Created by Nick Robison on 11/3/20.
//

import SwiftUI

struct UserLoginView: View {
    
    @Binding var user: ApplicationUser?
    let controller = LoginViewController()
    
    var body: some View {
        VStack {
            Text("Login to Okta")
            controller
        }
        .onAppear(perform: self.loginUser)
    }
    
    private func loginUser() {
        debugPrint("Logging in user")
        self.controller.loginUser { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                debugPrint("Error logging in \(error)")
            }
        }
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserLoginView(user: .constant(nil))
    }
}
