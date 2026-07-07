//
//  WeekDatesRow.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - WeekDatesRow

struct WeekDatesRow: View {
    let weekDates: [Date]
    let calendar: Calendar
    let activityRecords: [String: String]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<weekDates.count, id: \.self) { i in
                let date = weekDates[i]
                let key = date.keyString()
                let status = activityRecords[key]
                VStack {
                    DayCellView(
                        dayNumber: calendar.component(.day, from: date),
                        status: status,
                        isToday: calendar.isDateInToday(date)
                    )
                }.frame(maxWidth: .infinity)
            }
        }
    }
}
