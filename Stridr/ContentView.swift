//
//  ContentView.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/21/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if let session = AuthService.shared.currentSession {
            StridrTabView()
                .task {
                    do {
                        try await HealthManager.shared.requestAuthorization()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
