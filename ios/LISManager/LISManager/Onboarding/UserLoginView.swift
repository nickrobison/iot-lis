//
//  UserLoginView.swift
//  LISManager
//
//  Created by Nick Robison on 11/3/20.
//

import SwiftUI

struct UserLoginView: View {
    
    @Binding var user: ApplicationUser?
    
    var body: some View {
        VStack {
            Text("Login to Okta")
            makeController()
        }
        
    }
    
    private func makeController() -> LoginViewController {
        let controller = LoginViewController()
        controller.handler = { user in
            self.user = user
        }
        return controller
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserLoginView(user: .constant(nil))
    }
}
