//
//  MonthYearPickerOverlay.swift
//  LearningJourneyApp
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - MonthYearPickerOverlay

struct MonthYearPickerOverlay: View {
    @Binding var showMonthYearPicker: Bool
    @Binding var pickerMonthIndex: Int
    @Binding var pickerYear: Int
    @Binding var displayedWeekStart: Date
    let calendar: Calendar

    private var monthSymbols: [String] { calendar.shortMonthSymbols }
    private var minYear: Int { 2025 }
    @State private var arrayPickerYear: Int

    private var displayedYears: [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array(minYear...max(minYear + 10, currentYear + 5)).sorted()
    }

    init(showMonthYearPicker: Binding<Bool>, pickerMonthIndex: Binding<Int>, pickerYear: Binding<Int>, displayedWeekStart: Binding<Date>, calendar: Calendar) {
        self._showMonthYearPicker = showMonthYearPicker
        self._pickerMonthIndex = pickerMonthIndex
        self._pickerYear = pickerYear
        self._displayedWeekStart = displayedWeekStart
        self.calendar = calendar
        _arrayPickerYear = State(initialValue: pickerYear.wrappedValue)
    }

    var body: some View {
        ZStack {
            Color("PopoverBackground")
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Picker("Month", selection: $pickerMonthIndex) {
                        ForEach(0..<monthSymbols.count, id: \.self) { idx in
                            Text(monthSymbols[idx]).tag(idx).font(.system(size: 20)).foregroundColor(.white)
                        }
                    }
                    .labelsHidden().pickerStyle(.wheel).clipped().onChange(of: pickerMonthIndex) { _ in applySelection() }

                    Picker("Year", selection: $arrayPickerYear) {
                        ForEach(displayedYears, id: \.self) { y in
                            Text("\(y)").tag(y).font(.system(size: 20)).foregroundColor(.white)
                        }
                    }
                    .labelsHidden().pickerStyle(.wheel).clipped()
                    .onChange(of: arrayPickerYear) { newValue in
                        pickerYear = max(newValue, minYear)
                        applySelection()
                    }
                }
                .padding(.horizontal, 8)
            }
        }
        .frame(width: 365, height: 253).cornerRadius(18)
        .shadow(color: Color.black.opacity(0.45), radius: 6, x: 0, y: 4)
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.15), lineWidth: 1))
        .onAppear { arrayPickerYear = pickerYear }
    }

    private func applySelection() {
        let targetMonth = pickerMonthIndex + 1
        let comps = DateComponents(year: pickerYear, month: targetMonth, day: 1)
        if let firstOfMonth = calendar.date(from: comps) {
            displayedWeekStart = firstOfMonth.startOfWeek(using: calendar)
        }
    }
}
