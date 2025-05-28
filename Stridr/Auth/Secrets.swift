//
//  Secrets.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/28/25.
//
import Foundation
import Supabase

struct Secrets {
    static var supabaseURL: URL {
        if let urlString = ProcessInfo.processInfo.environment["SUPABASE_URL"],
           let url = URL(string: urlString) {
            return url
        }
        
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let urlString = plist["SupabaseURL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("""
                Supabase URL not found. Please either:
                1. Set SUPABASE_URL environment variable, or
                2. Create Config.plist with SupabaseURL key
                """)
        }
        return url
    }
    
    static var supabaseKey: String {
        if let key = ProcessInfo.processInfo.environment["SUPABASE_KEY"] {
            return key
        }
        
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["SupabaseKey"] as? String else {
            fatalError("""
                Supabase key not found. Please either:
                1. Set SUPABASE_KEY environment variable, or
                2. Create Config.plist with SupabaseKey key
                """)
        }
        return key
    }
}
