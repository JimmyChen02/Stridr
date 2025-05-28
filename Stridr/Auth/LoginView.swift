//
//  LoginView.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/27/25.
//

import SwiftUI

struct LoginView: View {
    let blueGray = Color(red: 0.4, green: 0.55, blue: 0.7)

    @State var email: String = ""
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(height: 400)
            
            Text("Welcome Runners!")
                .font(.largeTitle)
                .bold()
                .frame(maxHeight: .infinity, alignment: .top)

            VStack {
                TextField("Email", text: $email)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                
                
                Button {
                    Task {
                        do {
                            try await AuthService.shared.magicLinkLogin(email: email)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Text("Login")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                        .background(blueGray)
                        .clipShape(Capsule())
                }
                .disabled(email.count < 7)
            }
            .padding()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .onOpenURL (perform: { url in
            Task {
                do {
                    try await AuthService.shared.handleOpenUrl(url: url)
                } catch {
                    print(error.localizedDescription)
                }
            }
        })
    }
}

#Preview {
    LoginView()
}
