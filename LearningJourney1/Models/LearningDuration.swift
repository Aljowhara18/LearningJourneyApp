//
//  LearningDuration.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//

// MARK: - Learning Duration

extension String {
    var learningDurationDays: Int {
        switch self {
        case "Week": return 7
        case "Month": return 30
        case "Year": return 365
        default: return 7
        }
    }
}
