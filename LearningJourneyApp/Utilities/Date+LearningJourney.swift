//
//  Date+LearningJourney.swift
//  LearningJourneyApp
//
//  Created by Jojo on 23/10/2025.
//

import Foundation

// MARK: - Date Extension

extension Date {
    func keyString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    func startOfWeek(using calendar: Calendar) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }

    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    }

    func daysInMonth(using calendar: Calendar) -> Int {
        calendar.range(of: .day, in: .month, for: self)?.count ?? 30
    }
}
