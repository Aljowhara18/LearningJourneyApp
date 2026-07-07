//
//  CalendarDayCell.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - CalendarDayCell

struct CalendarDayCell: View {
    let date: Date
    let calendar: Calendar
    let isCurrentMonth: Bool
    let isLearned: Bool
    let isFreezed: Bool
    let isToday: Bool

    private var day: Int { calendar.component(.day, from: date) }

    var body: some View {
        let status: String? = isLearned ? "learned" : (isFreezed ? "freezed" : nil)
        let learnedColor = Color("LearnedBrown")
        let freezedColor = Color("FreezedBlue")

        ZStack {
            if status == "learned" {
                Circle().fill(learnedColor).frame(width: 38, height: 38)
            } else if status == "freezed" {
                Circle().fill(freezedColor).frame(width: 38, height: 38)
            }
            else if isToday && isCurrentMonth {
                Circle().stroke(Color.white.opacity(0.4), lineWidth: 1.5).frame(width: 38, height: 38)
            }

            Text("\(day)")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(isCurrentMonth ? .white : .gray.opacity(0.4))
        }
        .frame(height: 40)
    }
}
