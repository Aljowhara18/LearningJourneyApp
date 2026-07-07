//
//  CalendarView.swift
//  LearningJourneyApp
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - CalendarView (الشاشة الرئيسية)

struct CalendarView: View {

    @StateObject private var viewModel = CalendarViewModel()
    @Environment(\.dismiss) var dismiss

    private let calendar = Calendar.current
    private let yearRange = -1...1

    private var monthsToDisplay: [Date] {
        var months: [Date] = []
        let currentYear = calendar.component(.year, from: Date())

        for yearOffset in yearRange {
            let targetYear = currentYear + yearOffset
            let dateComponents = DateComponents(year: targetYear, month: 1, day: 1)

            if var monthDate = calendar.date(from: dateComponents) {
                for _ in 1...12 {
                    if calendar.compare(monthDate, to: Date().startOfMonth(using: calendar), toGranularity: .month) == .orderedDescending && targetYear >= currentYear {
                        break
                    }
                    months.append(monthDate)
                    monthDate = calendar.date(byAdding: .month, value: 1, to: monthDate)!
                }
            }
        }
        return months.sorted().reversed()
    }

    private var weekdaySymbols: [String] {
        let symbols = calendar.shortWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1

        return (0..<7).map { index in
            symbols[(index + firstWeekdayIndex) % 7].uppercased()
        }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    ForEach(weekdaySymbols, id: \.self) { symbol in
                        Text(symbol).font(.system(size: 11, weight: .semibold)).foregroundColor(.gray).frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(monthsToDisplay, id: \.self) { monthDate in
                            MonthlyCalendarView(date: monthDate, activityRecords: viewModel.activityRecords)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 10)
                }

                Spacer(minLength: 0)
            }
        }
        .onAppear(perform: viewModel.loadRecords)
        .navigationTitle("All activities")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

// MARK: - Preview

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CalendarView()
        }
    }
}
