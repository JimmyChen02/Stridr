//
//  AuthService.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/27/25.
//

import Foundation
import Supabase
struct Secrets {
    static let supbaseURL = URL(string: "https://nbpzyusynuyrkknfpdfj.supabase.co")!
    static let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5icHp5dXN5bnV5cmtrbmZwZGZqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgzNjk0MTQsImV4cCI6MjA2Mzk0NTQxNH0.14z7f-dr0bnmEQBSFJyDd2h7gsCOls6UmYeTk-IylqE"
}
final class AuthService {
    static let shared = AuthService()
    private var supabase = SupabaseClient(supabaseURL: Secrets.supbaseURL, supabaseKey: Secrets.supabaseKey)
                                         
    private init () { }
    
    func magicLinkLogin(email: String) aync throws {
        try await supabase.auth.signInWithOTP(
          email: email,
          redirectTo: URL(string: "com.stridr-ny//login-callback")!
        )
    }
}
