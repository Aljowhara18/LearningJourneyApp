//
//  MonthlyCalendarView.swift
//  LearningJourneyApp
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - MonthlyCalendarView

struct MonthlyCalendarView: View {
    let date: Date
    let activityRecords: [String: String]
    let calendar = Calendar.current

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 7)

    private var days: [Date] {
        let startOfMonth = date.startOfMonth(using: calendar)
        let daysInMonth = startOfMonth.daysInMonth(using: calendar)
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let startDayOffset = (firstWeekday - calendar.firstWeekday + 7) % 7
        var dates: [Date] = []

        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth) {
            let daysInPreviousMonth = previousMonth.daysInMonth(using: calendar)
            for i in 0..<startDayOffset {
                if let date = calendar.date(byAdding: .day, value: daysInPreviousMonth - startDayOffset + i, to: previousMonth) {
                    dates.append(date)
                }
            }
        }

        for i in 0..<daysInMonth {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfMonth) {
                dates.append(date)
            }
        }

        let daysToFill = 42 - dates.count
        if daysToFill > 0, let nextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) {
            for i in 0..<daysToFill {
                if let date = calendar.date(byAdding: .day, value: i, to: nextMonth) {
                    dates.append(date)
                }
            }
        }
        return dates
    }

    private func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(monthYearString())
                .font(.system(size: 18, weight: .bold)).foregroundColor(.white).padding(.leading, 8)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(days.indices, id: \.self) { index in
                    let dayDate = days[index]
                    let isCurrent = calendar.isDate(dayDate, equalTo: date, toGranularity: .month)
                    let key = dayDate.keyString()
                    let status = activityRecords[key]

                    CalendarDayCell(
                        date: dayDate,
                        calendar: calendar,
                        isCurrentMonth: isCurrent,
                        isLearned: status == "learned",
                        isFreezed: status == "freezed",
                        isToday: calendar.isDateInToday(dayDate)
                    )
                }
            }
        }
        .padding(.bottom, 20)
    }
}
