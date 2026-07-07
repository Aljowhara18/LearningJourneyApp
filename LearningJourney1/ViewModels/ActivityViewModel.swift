//
//  ActivityViewModel.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//

import Foundation
import Combine

// MARK: - ActivityViewModel

final class ActivityViewModel: ObservableObject {

    // MARK: Published State
    @Published private(set) var activityRecords: [String: String] = [:]
    @Published private(set) var activityState: ActivityState = .default
    @Published private(set) var learnedDays: Int = 0
    @Published private(set) var freezedDays: Int = 0
    @Published private(set) var freezeLimit: Int = 2
    @Published var showAchievementSheet: Bool = false

    // MARK: Persistence Keys
    private let defaults = UserDefaults.standard
    private let recordsKey = "activityRecords"
    private let goalStartDateKey = "goalStartDate"
    private let calendar = Calendar.current

    private var goalStartDate: Date {
        let interval = defaults.double(forKey: goalStartDateKey)
        return interval == 0 ? Date() : Date(timeIntervalSince1970: interval)
    }

    private var selectedDuration: String {
        defaults.string(forKey: "selectedDuration") ?? "Week"
    }

    // MARK: - Lifecycle

    func onAppear() {
        if defaults.double(forKey: goalStartDateKey) == 0 {
            defaults.set(Date().timeIntervalSince1970, forKey: goalStartDateKey)
        }
        loadRecords()
        updateFreezeLimit()
        updateCounts()
    }

    // MARK: - Actions

    func mainCircleTapped() {
        let key = Date().keyString()
        switch activityState {
        case .default: activityRecords[key] = "learned"
        case .logged, .freezed: activityRecords.removeValue(forKey: key)
        }
        persistRecords()
        updateCounts()
    }

    func freezeButtonTapped() {
        let key = Date().keyString()
        switch activityState {
        case .default, .logged:
            guard freezedDays < freezeLimit else { return }
            activityRecords[key] = "freezed"
        case .freezed:
            activityRecords[key] = "learned"
        }
        persistRecords()
        updateCounts()
    }

    func resetStreakAndRecords() {
        activityRecords = [:]
        persistRecords()
        defaults.set(Date().timeIntervalSince1970, forKey: goalStartDateKey)
        updateCounts()
    }

    func onDurationChanged() {
        updateFreezeLimit()
    }

    // MARK: - Streak Logic

    private func computeStreakCounts() -> (learned: Int, freezed: Int) {
        var learned = 0
        var freezed = 0
        let start = calendar.startOfDay(for: goalStartDate)
        var cursor = calendar.startOfDay(for: Date())
        var daysScanned = 0

        while cursor >= start && daysScanned < 366 {
            switch activityRecords[cursor.keyString()] {
            case "learned": learned += 1
            case "freezed": freezed += 1
            default: return (learned, freezed)
            }
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: cursor) else { return (learned, freezed) }
            cursor = previousDay
            daysScanned += 1
        }
        return (learned, freezed)
    }

    private func updateCounts() {
        let streak = computeStreakCounts()
        learnedDays = streak.learned
        freezedDays = streak.freezed

        switch activityRecords[Date().keyString()] {
        case "learned": activityState = .logged
        case "freezed": activityState = .freezed
        default: activityState = .default
        }

        checkGoalCompletion()
    }

    private func checkGoalCompletion() {
        guard learnedDays + freezedDays >= selectedDuration.learningDurationDays else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in self?.showAchievementSheet = true }
    }

    private func updateFreezeLimit() {
        switch selectedDuration {
        case "Week": freezeLimit = 2
        case "Month": freezeLimit = 8
        case "Year": freezeLimit = 96
        default: freezeLimit = 2
        }
    }

    // MARK: - Persistence

    private func persistRecords() {
        if let data = try? JSONEncoder().encode(activityRecords) {
            defaults.set(String(data: data, encoding: .utf8) ?? "", forKey: recordsKey)
        }
    }

    private func loadRecords() {
        guard let raw = defaults.string(forKey: recordsKey), !raw.isEmpty,
              let data = raw.data(using: .utf8),
              let map = try? JSONDecoder().decode([String: String].self, from: data) else {
            activityRecords = [:]
            return
        }
        activityRecords = map
    }
}
