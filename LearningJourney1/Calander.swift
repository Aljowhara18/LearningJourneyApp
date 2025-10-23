//
//  Calander.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//
import SwiftUI
/*


import SwiftUI

// ⭐️ ملاحظة: تعتمد هذه الشاشة على Extensions من ملف Utilities.swift

// MARK: - CalendarDayCell (لا تغيير، تبقى كما هي)
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
        let learnedColor = Color(hex: "#4C311A") // بني (Learned)
        let freezedColor = Color(hex: "#1B3F4A") // أزرق داكن (Freezed)

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

// MARK: - MonthlyCalendarView (مكون فرعي لتمثيل شهر واحد)
private struct MonthlyCalendarView: View {
    let date: Date
    let activityRecords: [String: String]
    let calendar = Calendar.current
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 7)
    
    // حساب الأيام لهذا الشهر (مثلما كان في الدالة القديمة)
    private var days: [Date] {
        let startOfMonth = date.startOfMonth(using: calendar)
        let daysInMonth = startOfMonth.daysInMonth(using: calendar)
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let startDayOffset = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        var dates: [Date] = []
        
        // أيام الشهر السابق
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth) {
            let daysInPreviousMonth = previousMonth.daysInMonth(using: calendar)
            for i in 0..<startDayOffset {
                if let date = calendar.date(byAdding: .day, value: daysInPreviousMonth - startDayOffset + i, to: previousMonth) {
                    dates.append(date)
                }
            }
        }
        
        // أيام الشهر الحالي
        for i in 0..<daysInMonth {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfMonth) {
                dates.append(date)
            }
        }
        
        // أيام الشهر التالي لملء الصف
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
            // عنوان الشهر
            Text(monthYearString())
                .font(.system(size: 18, weight: .bold)).foregroundColor(.white).padding(.leading, 8)
            
            // شبكة الأيام
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
        .padding(.bottom, 20) // فاصل بين الشهور
    }
}


// MARK: - CalendarView (الشاشة الرئيسية)

struct CalendarView: View {
    
    @State private var activityRecords: [String: String] = [:]
    @AppStorage("activityRecords") private var activityRecordsData: String = ""
    @Environment(\.dismiss) var dismiss // لاستخدام زر العودة

    private let calendar = Calendar.current
    private let yearRange = -1...1 // عرض سنة سابقة، السنة الحالية، وسنة قادمة (3 سنوات)
    
    // حساب قائمة بالتواريخ التي تمثل اليوم الأول من كل شهر نرغب بعرضه
    private var monthsToDisplay: [Date] {
        var months: [Date] = []
        let currentYear = calendar.component(.year, from: Date())
        
        for yearOffset in yearRange {
            let targetYear = currentYear + yearOffset
            var dateComponents = DateComponents(year: targetYear, month: 1, day: 1)
            
            if var monthDate = calendar.date(from: dateComponents) {
                for _ in 1...12 {
                    // نوقف إضافة الشهور إذا تجاوزنا الشهر الحالي
                    if calendar.compare(monthDate, to: Date().startOfMonth(using: calendar), toGranularity: .month) == .orderedDescending && targetYear > currentYear {
                        break
                    }
                    months.append(monthDate)
                    monthDate = calendar.date(byAdding: .month, value: 1, to: monthDate)!
                }
            }
        }
        return months.sorted().reversed() // عرض الشهور بترتيب تنازلي (الأحدث أولاً)
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
                // أسماء أيام الأسبوع (تبقى في الأعلى وغير قابلة للتمرير)
                HStack(spacing: 10) {
                    ForEach(weekdaySymbols, id: \.self) { symbol in
                        Text(symbol).font(.system(size: 11, weight: .semibold)).foregroundColor(.gray).frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                // قائمة الشهور (قابلة للتمرير)
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(monthsToDisplay, id: \.self) { monthDate in
                            MonthlyCalendarView(date: monthDate, activityRecords: activityRecords)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 10)
                }
                
                Spacer(minLength: 0)
            }
        }
        .onAppear(perform: loadRecords)
        .navigationTitle("All activities") // حسب الصورة المرفقة
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    // MARK: - Logic
    
    private func loadRecords() {
        guard let data = activityRecordsData.data(using: .utf8),
              let map = try? JSONDecoder().decode([String: String].self, from: data) else {
            activityRecords = [:]
            return
        }
        activityRecords = map
    }
}

// MARK: - PREVIEW
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CalendarView()
        }
    }
}
*/

import SwiftUI

// MARK: - CalendarDayCell (المكونات الفرعية تبقى كما هي)
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
        let learnedColor = Color(hex: "#4C311A")
        let freezedColor = Color(hex: "#1B3F4A")

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

// MARK: - MonthlyCalendarView (المكونات الفرعية تبقى كما هي)
private struct MonthlyCalendarView: View {
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


// MARK: - CalendarView (الشاشة الرئيسية)

struct CalendarView: View {
    
    @State private var activityRecords: [String: String] = [:]
    @AppStorage("activityRecords") private var activityRecordsData: String = ""
    @Environment(\.dismiss) var dismiss

    private let calendar = Calendar.current
    private let yearRange = -1...1
    
    private var monthsToDisplay: [Date] {
        var months: [Date] = []
        let currentYear = calendar.component(.year, from: Date())
        
        for yearOffset in yearRange {
            let targetYear = currentYear + yearOffset
            var dateComponents = DateComponents(year: targetYear, month: 1, day: 1)
            
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
                            MonthlyCalendarView(date: monthDate, activityRecords: activityRecords)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 10)
                }
                
                Spacer(minLength: 0)
            }
        }
        .onAppear(perform: loadRecords)
        .navigationTitle("All activities")
        .navigationBarTitleDisplayMode(.inline)
        
        // ⭐️⭐️ السطر الذي يحل المشكلة: إخفاء الزر التلقائي ⭐️⭐️
        .navigationBarBackButtonHidden(true)
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                // هذا هو زر الرجوع الوحيد الذي سيظهر الآن
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    // MARK: - Logic
    
    private func loadRecords() {
        guard let data = activityRecordsData.data(using: .utf8),
              let map = try? JSONDecoder().decode([String: String].self, from: data) else {
            activityRecords = [:]
            return
        }
        activityRecords = map
    }
}

// MARK: - PREVIEW
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CalendarView()
        }
    }
}
