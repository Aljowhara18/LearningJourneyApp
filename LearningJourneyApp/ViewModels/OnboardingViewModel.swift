//
//  OnboardingViewModel.swift
//  LearningJourneyApp
//
//  Created by Jojo on 23/10/2025.
//

import Foundation
import Combine

// MARK: - OnboardingViewModel

final class OnboardingViewModel: ObservableObject {
    @Published var learningTopic: String = ""
    @Published var selectedDuration: String = "Week"

    let durations = ["Week", "Month", "Year"]

    private let defaults = UserDefaults.standard

    init() {
        learningTopic = defaults.string(forKey: "learningTopic") ?? ""
        selectedDuration = defaults.string(forKey: "selectedDuration") ?? "Week"
    }

    var canStart: Bool {
        !learningTopic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func startLearning() {
        defaults.set(learningTopic, forKey: "learningTopic")
        defaults.set(selectedDuration, forKey: "selectedDuration")
        defaults.set(Date().timeIntervalSince1970, forKey: "goalStartDate")
    }
}
