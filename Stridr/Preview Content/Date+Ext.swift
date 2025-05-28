//
//  Date+Ext.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/27/25.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
    func timeOfDayString() -> String {
        let hour = Calendar.current.component(.hour, from: self)
        switch hour {
        case 3..<11:
            return "Morning Run"
        case 11..<14:
            return "Lunch Run"
        case 14..<21:
            return "Evening Run"
        default:
            return "Night Run"
        }
    }
}
