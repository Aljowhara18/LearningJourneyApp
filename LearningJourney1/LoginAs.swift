//
//  LoginAs.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// ⭐️ ملاحظة: تم نقل الـ Extensions إلى ملف Utilities.swift

// MARK: - Componentes Auxiliares (تبقى هنا)

enum ActivityState {
    case `default`
    case logged
    case freezed
}

private struct DayCellView: View {
    let dayNumber: Int
    let status: String?
    let isToday: Bool

    var body: some View {
        ZStack {
            // ... (باقي محتوى DayCellView)
            if status == "learned" {
                Circle().fill(Color(hex: "#4C311A")).frame(width: 34, height: 34)
            } else if status == "freezed" {
                Circle().fill(Color(hex: "#1B3F4A")).frame(width: 34, height: 34)
            } else if isToday {
                Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1).frame(width: 34, height: 34)
            } else {
                Circle().fill(Color.black.opacity(0.18)).frame(width: 34, height: 34)
            }
            Text("\(dayNumber)").font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
        }
    }
}

private struct MonthYearPickerOverlay: View {
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
            Color(hex: "#1C1C1E")
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

private struct WeekdayLabelsRow: View {
    let symbols: [String]
    var body: some View {
        HStack(spacing: 12) {
            ForEach(Array(symbols.enumerated()), id: \.offset) { _, sym in
                Text(sym).font(.system(size: 11, weight: .semibold)).foregroundColor(.gray).frame(maxWidth: .infinity)
            }
        }
    }
}

private struct WeekDatesRow: View {
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

private struct AchievementBottomSheetView: View {
    @Environment(\.dismiss) var dismiss
    let onNavigateToUpdateGoal: () -> Void
    let onContinueSameGoal: () -> Void

    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            Image(systemName: "hands.and.sparkles.fill").resizable().scaledToFit().frame(width: 70, height: 70).foregroundColor(Color(hex: "#FF9230")).padding(.bottom, 10)
            Text("Well done!").font(.system(size: 28, weight: .bold)).foregroundColor(.white).padding(.top, -10)
            Text("Goal completed! start learning again or\nset new learning goal").font(.system(size: 16)).foregroundColor(Color.gray.opacity(0.8)).multilineTextAlignment(.center).padding(.horizontal)
            Spacer()
            
            Button(action: {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { onNavigateToUpdateGoal() }
            }) {
                Text("Set new learning goal").font(.system(size: 18, weight: .medium)).foregroundColor(.white)
                    .frame(width: 246, height: 48).background(RoundedRectangle(cornerRadius: 24).fill(Color(hex: "#FF9230")))
            }

            Button(action: {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { onContinueSameGoal() }
            }) {
                Text("Set same learning goal and duration").font(.system(size: 16, weight: .regular)).foregroundColor(Color(hex: "#FF9230"))
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.black)
    }
}

// MARK: - LoginAsView (Activity Page)

struct LoginAsView: View {
    @AppStorage("learningTopic") internal var learningTopic: String = "Swift"
    @AppStorage("selectedDuration") internal var selectedDuration: String = "Week"

    @AppStorage("activityRecords") private var activityRecordsData: String = ""
    @State private var activityRecords: [String: String] = [:]

    @State private var activityState: ActivityState = .default
    @State private var learnedDays: Int = 0
    @State private var freezedDays: Int = 0
    @State private var freezeLimit: Int = 2
    
    @State private var showAchievementSheet: Bool = false
    @State private var navigateToUpdateGoal: Bool = false

    @State private var displayedWeekStart: Date = Date().startOfWeek(using: Calendar.current)

    @State private var showMonthYearPicker: Bool = false
    @State private var pickerMonthIndex: Int = Calendar.current.component(.month, from: Date()) - 1
    @State private var pickerYear: Int = max(Calendar.current.component(.year, from: Date()), 2025)

    private let calendar = Calendar.current
    private var daySymbols: [String] { calendar.shortWeekdaySymbols.map { $0.uppercased() } }

    var body: some View {
        
        let reorderedSymbols: [String] = (0..<7).map { idx in
            daySymbols[(idx + calendar.firstWeekday - 1) % 7]
        }
        let weekDates: [Date] = (0..<7).compactMap { i in
            calendar.date(byAdding: .day, value: i, to: displayedWeekStart)
        }

        let updateGoalDestination = UpdateLearningGoalView(
            isNavigationActive: $navigateToUpdateGoal,
            onGoalUpdated: {
                self.resetStreakAndRecords()
                self.updateFreezeLimit()
            },
            currentTopic: learningTopic,
            currentDuration: selectedDuration
        )

        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 18) {
                    // Header
                    HStack {
                        Text("Activity").font(.system(size: 30, weight: .bold)).foregroundColor(.white)
                        Spacer()
                        HStack(spacing: 16) {
                            // Calendar Icon
                            NavigationLink(destination: CalendarView()) {
                                Image(systemName: "calendar").font(.system(size: 20)).foregroundColor(.white)
                            }
                            // Goal Update Icon (pencil.and.outline)
                            NavigationLink(destination: updateGoalDestination, isActive: $navigateToUpdateGoal) {
                                Image(systemName: "pencil.and.outline").font(.system(size: 20)).foregroundColor(.white)
                            }
                            .isDetailLink(false)
                        }
                    }
                    .padding(.horizontal)

                    // Calendar Box (rounded)
                    VStack(spacing: 12) {
                        // top row: month/year + week nav
                        HStack {
                            Button(action: {
                                showMonthYearPicker.toggle()
                                let currentMonth = calendar.component(.month, from: displayedWeekStart)
                                pickerMonthIndex = currentMonth - 1
                                pickerYear = calendar.component(.year, from: displayedWeekStart)
                            }) {
                                HStack(spacing: 6) {
                                    Text(displayedMonthYearString()).font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                                    Image(systemName: "chevron.down").foregroundColor(Color(hex: "#FF9230"))
                                }
                            }
                            Spacer()
                            HStack(spacing: 18) {
                                Button(action: { moveWeek(by: -1) }) { Image(systemName: "chevron.left").foregroundColor(Color(hex: "#FF9230")) }
                                Button(action: { moveWeek(by: 1) }) { Image(systemName: "chevron.right").foregroundColor(Color(hex: "#FF9230")) }
                            }
                        }

                        // weekday labels
                        WeekdayLabelsRow(symbols: reorderedSymbols)

                        // dates row (week)
                        WeekDatesRow(weekDates: weekDates, calendar: calendar, activityRecords: activityRecords)

                        Divider().background(Color.white.opacity(0.06))

                        // Learning topic + streak boxes
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Learning").font(.system(size: 18, weight: .regular)).foregroundColor(.white)
                                Text(learningTopic.isEmpty ? "—" : learningTopic).font(.system(size: 18, weight: .regular)).foregroundColor(.white).bold()
                                Spacer()
                            }

                            HStack(spacing: 16) {
                                streakBox(icon: "flame.fill", count: learnedDays, label: "Days Learned", color: Color(hex: "#4C311A"))
                                streakBox(icon: "cube.fill", count: freezedDays, label: "Days Freezed", color: Color(hex: "#1B3F4A"))
                            }
                        }.padding(.top, 6)
                    }
                    .padding().background(Color.black.opacity(0.4)).cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.3), lineWidth: 1)).padding(.horizontal)

                    Spacer()

                    // Main circle action
                    Button(action: mainCircleTapped) {
                        ZStack {
                            Circle().fill(circleMainColor()).frame(width: 274, height: 274)
                                .shadow(color: circleShadowColor(), radius: 20, x: 0, y: 10)
                            Text(circleText()).font(.system(size: 28, weight: .bold)).multilineTextAlignment(.center).foregroundColor(.white)
                        }
                    }

                    // Freeze button
                    Button(action: freezeButtonTapped) {
                        Text(freezeButtonText()).font(.system(size: 18, weight: .medium)).foregroundColor(.white)
                            .frame(width: 274, height: 48).background(RoundedRectangle(cornerRadius: 24).fill(freezeButtonColor()))
                    }
                    .disabled(freezedDays >= freezeLimit && activityState != .logged)
                    .opacity(freezedDays >= freezeLimit && activityState != .logged ? 0.6 : 1.0)

                    Text("\(freezedDays) out of \(freezeLimit) Freezes used").font(.system(size: 13)).foregroundColor(.gray)

                    Spacer(minLength: 20)
                }.padding(.vertical, 8)

                // NavigationLink مخفي
                NavigationLink(destination: updateGoalDestination, isActive: $navigateToUpdateGoal) { EmptyView() }.hidden()
                
                // Month/Year Picker Overlay
                Group {
                    if showMonthYearPicker {
                        Color.clear.contentShape(Rectangle()).onTapGesture { showMonthYearPicker = false }
                        MonthYearPickerOverlay(
                            showMonthYearPicker: $showMonthYearPicker,
                            pickerMonthIndex: $pickerMonthIndex,
                            pickerYear: $pickerYear,
                            displayedWeekStart: $displayedWeekStart,
                            calendar: calendar
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading).padding(.top, 95).padding(.leading, 20)
                    }
                }
            }
            .onAppear {
                loadRecords()
                updateCounts()
                updateFreezeLimit()
                displayedWeekStart = Date().startOfWeek(using: calendar)
                if activityRecords[Date().keyString()] == "learned" { activityState = .logged }
                else if activityRecords[Date().keyString()] == "freezed" { activityState = .freezed }
                else { activityState = .default }
            }
            .onChange(of: selectedDuration) { _ in updateFreezeLimit() }
            .navigationBarBackButtonHidden(true).navigationBarHidden(true)
        }
        .sheet(isPresented: $showAchievementSheet) {
            AchievementBottomSheetView(
                onNavigateToUpdateGoal: { self.navigateToUpdateGoal = true },
                onContinueSameGoal: { self.resetStreakAndRecords() }
            )
            .presentationDetents([.medium, .large]).presentationBackground(.black).presentationDragIndicator(.hidden)
        }
    }

    // MARK: - Logic/Actions
    func resetStreakAndRecords() { activityRecords = [:]; persistRecords(); updateCounts(); activityState = .default; }
    private func mainCircleTapped() {
        let today = Date(); let key = today.keyString(); var shouldShowSheet = false
        switch activityState {
        case .default: activityState = .logged; activityRecords[key] = "learned"; shouldShowSheet = true
        case .logged: activityState = .default; activityRecords.removeValue(forKey: key)
        case .freezed: activityState = .default; activityRecords.removeValue(forKey: key)
        }
        persistRecords(); updateCounts()
        if shouldShowSheet { DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { self.showAchievementSheet = true } }
    }
    private func freezeButtonTapped() {
        let today = Date(); let key = today.keyString()
        if activityState == .default || activityState == .logged {
            if freezedDays < freezeLimit {
                activityState = .freezed; activityRecords[key] = "freezed"; persistRecords(); updateCounts()
            }
        } else if activityState == .freezed {
            activityState = .logged; activityRecords[key] = "learned"; persistRecords(); updateCounts()
        }
    }
    private func moveWeek(by weeks: Int) {
        if let newStart = calendar.date(byAdding: .day, value: weeks * 7, to: displayedWeekStart) { displayedWeekStart = newStart }
    }
    private func persistRecords() {
        if let data = try? JSONEncoder().encode(activityRecords) { activityRecordsData = String(data: data, encoding: .utf8) ?? "" }
    }
    private func loadRecords() {
        guard !activityRecordsData.isEmpty, let data = activityRecordsData.data(using: .utf8),
              let map = try? JSONDecoder().decode([String: String].self, from: data) else { activityRecords = [:]; return }
        activityRecords = map
    }
    private func updateCounts() {
        learnedDays = activityRecords.values.filter { $0 == "learned" }.count
        freezedDays = activityRecords.values.filter { $0 == "freezed" }.count
        if activityRecords[Date().keyString()] == "learned" { activityState = .logged }
        else if activityRecords[Date().keyString()] == "freezed" { activityState = .freezed }
        else { activityState = .default }
    }
    internal func updateFreezeLimit() {
        switch selectedDuration {
        case "Week": freezeLimit = 2
        case "Month": freezeLimit = 8
        case "Year": freezeLimit = 96
        default: freezeLimit = 2
        }
    }
    private func freezeButtonText() -> String { activityState == .freezed ? "Log as Learned" : "Log as Freezed" }
    private func freezeButtonColor() -> Color { activityState == .freezed ? Color(hex: "#4C311A") : Color(hex: "#00D2E0") }
    private func displayedMonthYearString() -> String {
        let month = calendar.component(.month, from: displayedWeekStart)
        let year = calendar.component(.year, from: displayedWeekStart)
        return "\(calendar.monthSymbols[month - 1]) \(year)"
    }
    private func circleMainColor() -> Color {
        switch activityState {
        case .default: return Color(hex: "#FF9230")
        case .logged: return Color(hex: "#4C311A")
        case .freezed: return Color(hex: "#1B3F4A")
        }
    }
    private func circleShadowColor() -> Color {
        switch activityState {
        case .default: return Color.orange.opacity(0.6)
        case .logged: return Color.orange.opacity(0.3)
        case .freezed: return Color.cyan.opacity(0.4)
        }
    }
    private func circleText() -> String {
        switch activityState {
        case .default: return "Log as\nLearned"
        case .logged: return "Learned\nToday"
        case .freezed: return "Day\nFreezed"
        }
    }
    private func streakBox(icon: String, count: Int, label: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 18)).foregroundColor(.white)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(count)").font(.system(size: 20, weight: .bold)).foregroundColor(.white)
                Text(label).font(.system(size: 13)).foregroundColor(.white.opacity(0.7))
            }
        }.frame(width: 160, height: 69).background(color).cornerRadius(18)
        .shadow(color: color.opacity(0.45), radius: 6, x: 0, y: 4)
    }
}

// MARK: - PREVIEW
struct LoginAsView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAsView()
    }
}
