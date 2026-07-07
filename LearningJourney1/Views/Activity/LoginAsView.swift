//
//  LoginAsView.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - LoginAsView (Activity Page)

struct LoginAsView: View {

    // MARK: Goal Properties
    @AppStorage("learningTopic") internal var learningTopic: String = "Swift"
    @AppStorage("selectedDuration") internal var selectedDuration: String = "Week"

    // MARK: ViewModel
    @StateObject private var viewModel = ActivityViewModel()

    // MARK: Navigation/Sheets
    @State private var navigateToUpdateGoal: Bool = false

    // MARK: Calendar Display
    @State private var displayedWeekStart: Date = Date().startOfWeek(using: Calendar.current)
    @State private var showMonthYearPicker: Bool = false
    @State private var pickerMonthIndex: Int = Calendar.current.component(.month, from: Date()) - 1
    @State private var pickerYear: Int = max(Calendar.current.component(.year, from: Date()), 2025)

    private let calendar = Calendar.current
    private var daySymbols: [String] { calendar.shortWeekdaySymbols.map { $0.uppercased() } }

    // MARK: - Body

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
                viewModel.resetStreakAndRecords()
                viewModel.onDurationChanged()
            },
            currentTopic: learningTopic,
            currentDuration: selectedDuration
        )

        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 18) {
                    HStack {
                        Text("Activity").font(.system(size: 30, weight: .bold)).foregroundColor(.white)
                        Spacer()
                        HStack(spacing: 16) {
                            NavigationLink(destination: CalendarView()) {
                                Image(systemName: "calendar").font(.system(size: 20)).foregroundColor(.white)
                            }
                            NavigationLink(destination: updateGoalDestination, isActive: $navigateToUpdateGoal) {
                                Image(systemName: "pencil.and.outline").font(.system(size: 20)).foregroundColor(.white)
                            }
                            .isDetailLink(false)
                        }
                    }
                    .padding(.horizontal)

                    VStack(spacing: 12) {
                        HStack {
                            Button(action: {
                                showMonthYearPicker.toggle()
                                let currentMonth = calendar.component(.month, from: displayedWeekStart)
                                pickerMonthIndex = currentMonth - 1
                                pickerYear = calendar.component(.year, from: displayedWeekStart)
                            }) {
                                HStack(spacing: 6) {
                                    Text(displayedMonthYearString()).font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                                    Image(systemName: "chevron.down").foregroundColor(Color("AccentOrange"))
                                }
                            }
                            Spacer()
                            HStack(spacing: 18) {
                                Button(action: { moveWeek(by: -1) }) { Image(systemName: "chevron.left").foregroundColor(Color("AccentOrange")) }
                                Button(action: { moveWeek(by: 1) }) { Image(systemName: "chevron.right").foregroundColor(Color("AccentOrange")) }
                            }
                        }

                        WeekdayLabelsRow(symbols: reorderedSymbols)

                        WeekDatesRow(weekDates: weekDates, calendar: calendar, activityRecords: viewModel.activityRecords)

                        Divider().background(Color.white.opacity(0.06))

                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Learning").font(.system(size: 18, weight: .regular)).foregroundColor(.white)
                                Text(learningTopic.isEmpty ? "—" : learningTopic).font(.system(size: 18, weight: .regular)).foregroundColor(.white).bold()
                                Spacer()
                            }

                            HStack(spacing: 16) {
                                streakBox(icon: "flame.fill", count: viewModel.learnedDays, label: "Days Learned", color: Color("LearnedBrown"))
                                streakBox(icon: "cube.fill", count: viewModel.freezedDays, label: "Days Freezed", color: Color("FreezedBlue"))
                            }
                        }.padding(.top, 6)
                    }
                    .padding().background(Color.black.opacity(0.4)).cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.3), lineWidth: 1)).padding(.horizontal)

                    Spacer()

                    Button(action: viewModel.mainCircleTapped) {
                        ZStack {
                            Circle().fill(circleMainColor()).frame(width: 274, height: 274)
                                .shadow(color: circleShadowColor(), radius: 20, x: 0, y: 10)
                            Text(circleText()).font(.system(size: 28, weight: .bold)).multilineTextAlignment(.center).foregroundColor(.white)
                        }
                    }

                    Button(action: viewModel.freezeButtonTapped) {
                        Text(freezeButtonText()).font(.system(size: 18, weight: .medium)).foregroundColor(.white)
                            .frame(width: 274, height: 48).background(RoundedRectangle(cornerRadius: 24).fill(freezeButtonColor()))
                    }
                    .disabled(viewModel.freezedDays >= viewModel.freezeLimit && viewModel.activityState != .logged)
                    .opacity(viewModel.freezedDays >= viewModel.freezeLimit && viewModel.activityState != .logged ? 0.6 : 1.0)

                    Text("\(viewModel.freezedDays) out of \(viewModel.freezeLimit) Freezes used").font(.system(size: 13)).foregroundColor(.gray)

                    Spacer(minLength: 20)
                }.padding(.vertical, 8)

                NavigationLink(destination: updateGoalDestination, isActive: $navigateToUpdateGoal) { EmptyView() }.hidden()

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
                viewModel.onAppear()
                displayedWeekStart = Date().startOfWeek(using: calendar)
            }
            .onChange(of: selectedDuration) { _ in viewModel.onDurationChanged() }
            .navigationBarBackButtonHidden(true).navigationBarHidden(true)
        }
        .sheet(isPresented: $viewModel.showAchievementSheet) {
            AchievementBottomSheetView(
                onNavigateToUpdateGoal: { navigateToUpdateGoal = true },
                onContinueSameGoal: { viewModel.resetStreakAndRecords() }
            )
            .presentationDetents([.medium, .large]).presentationBackground(.black).presentationDragIndicator(.hidden)
        }
    }

    // MARK: - Actions

    private func moveWeek(by weeks: Int) {
        if let newStart = calendar.date(byAdding: .day, value: weeks * 7, to: displayedWeekStart) { displayedWeekStart = newStart }
    }

    // MARK: - Display Helpers

    private func freezeButtonText() -> String { viewModel.activityState == .freezed ? "Log as Learned" : "Log as Freezed" }
    private func freezeButtonColor() -> Color { viewModel.activityState == .freezed ? Color("LearnedBrown") : Color("FreezeCyan") }

    private func displayedMonthYearString() -> String {
        let month = calendar.component(.month, from: displayedWeekStart)
        let year = calendar.component(.year, from: displayedWeekStart)
        return "\(calendar.monthSymbols[month - 1]) \(year)"
    }

    private func circleMainColor() -> Color {
        switch viewModel.activityState {
        case .default: return Color("AccentOrange")
        case .logged: return Color("LearnedBrown")
        case .freezed: return Color("FreezedBlue")
        }
    }

    private func circleShadowColor() -> Color {
        switch viewModel.activityState {
        case .default: return Color.orange.opacity(0.6)
        case .logged: return Color.orange.opacity(0.3)
        case .freezed: return Color.cyan.opacity(0.4)
        }
    }

    private func circleText() -> String {
        switch viewModel.activityState {
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

// MARK: - Preview

struct LoginAsView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAsView()
    }
}
