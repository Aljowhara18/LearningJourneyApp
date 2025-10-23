//
//  Utilities.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI
/*
// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

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

// MARK: - View Extension (Placeholder)
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
*/
import SwiftUI

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

// MARK: - Date Extension
extension Date {
    /**
     * يحول التاريخ إلى سلسلة نصية بصيغة YYYY-MM-DD لاستخدامها كمفتاح في سجل النشاط.
     */
    func keyString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    /**
     * يعيد تاريخ بداية الأسبوع الذي ينتمي إليه هذا التاريخ.
     */
    func startOfWeek(using calendar: Calendar) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }
    
    /**
     * يعيد تاريخ بداية الشهر الذي ينتمي إليه هذا التاريخ (اليوم الأول من الشهر).
     */
    func startOfMonth(using calendar: Calendar) -> Date {
        // نستخدم [ .year, .month ] فقط لتجاهل اليوم والوقت والرجوع إلى اليوم الأول.
        calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    }
    
    /**
     * يعيد عدد الأيام في الشهر الذي ينتمي إليه هذا التاريخ.
     */
    func daysInMonth(using calendar: Calendar) -> Int {
        calendar.range(of: .day, in: .month, for: self)?.count ?? 30
    }
}

// MARK: - View Extension (Placeholder)
extension View {
    /**
     * يضيف نص Placeholder لـ TextField أو TextEditor عندما تكون القيمة فارغة.
     */
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
