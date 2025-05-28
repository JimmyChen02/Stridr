//
//  AuthService.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/27/25.
//

import Foundation
import Supabase

@Observable
final class AuthService {
    static let shared = AuthService()
    private var supabase = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseKey)
    
    var currentSession : Session?
    private init () {
        Task {
            currentSession = try? await supabase.auth.session
        }
    }
    
    func magicLinkLogin(email: String) async throws {
        try await supabase.auth.signInWithOTP(
          email: email,
          redirectTo: URL(string: "com.stridr-ny://login-callback")!
        )
    }
    func handleOpenUrl(url: URL) async throws {
        currentSession = try await supabase.auth.session(from: url)
    }
    
    func logout()  async throws{
        try await supabase.auth.signOut()
        currentSession = nil
    }
}
