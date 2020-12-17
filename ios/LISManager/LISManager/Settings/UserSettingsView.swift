//
//  UserSettingsView.swift
//  LISManager
//
//  Created by Nick Robison on 11/3/20.
//

import SwiftUI

struct UserSettingsView: View {
    let user: ApplicationUser
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                InitialsView(name: self.user.toComponent())
                VStack(alignment: .leading) {
                    Text(self.user.lastName).font(.title)
                    Text(self.user.firstName).font(.callout)
                    Text(self.user.username).font(.caption).italic().foregroundColor(.secondary)
                }
            }
        }
        .padding([.leading, .trailing])
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView(user: ApplicationUser(id: "1", firstName: "Test", lastName: "User", username: "test@test.com", organizationID: UUID()))
    }
}
