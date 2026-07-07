//
//  UpdateLearningGoalViewModel.swift
//  LearningJourneyApp
//
//  Created by Jojo on 23/10/2025.
//

import Foundation
import Combine

// MARK: - UpdateLearningGoalViewModel

final class UpdateLearningGoalViewModel: ObservableObject {
    @Published var learningTopic: String {
        didSet { UserDefaults.standard.set(learningTopic, forKey: "learningTopic") }
    }
    @Published var selectedDuration: String {
        didSet { UserDefaults.standard.set(selectedDuration, forKey: "selectedDuration") }
    }
    @Published var showConfirmationPopover = false

    let durations = ["Week", "Month", "Year"]

    private var originalTopic: String
    private var originalDuration: String

    init(currentTopic: String, currentDuration: String) {
        learningTopic = currentTopic
        originalTopic = currentTopic
        selectedDuration = currentDuration
        originalDuration = currentDuration
    }

    var isGoalChanged: Bool {
        let currentTopicTrimmed = learningTopic.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let originalTopicTrimmed = originalTopic.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return currentTopicTrimmed != originalTopicTrimmed || selectedDuration != originalDuration
    }

    var isTopicEmpty: Bool {
        learningTopic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func confirmUpdate(onGoalUpdated: () -> Void) {
        onGoalUpdated()
        originalTopic = learningTopic
        originalDuration = selectedDuration
    }
}
