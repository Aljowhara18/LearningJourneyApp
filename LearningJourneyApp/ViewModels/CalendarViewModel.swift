//
//  CalendarViewModel.swift
//  LearningJourneyApp
//
//  Created by Jojo on 23/10/2025.
//

import Foundation
import Combine

// MARK: - CalendarViewModel

final class CalendarViewModel: ObservableObject {
    @Published var activityRecords: [String: String] = [:]

    func loadRecords() {
        guard let raw = UserDefaults.standard.string(forKey: "activityRecords"), !raw.isEmpty,
              let data = raw.data(using: .utf8),
              let map = try? JSONDecoder().decode([String: String].self, from: data) else {
            activityRecords = [:]
            return
        }
        activityRecords = map
    }
}
