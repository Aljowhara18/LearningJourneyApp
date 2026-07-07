//
//  WeekdayLabelsRow.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - WeekdayLabelsRow

struct WeekdayLabelsRow: View {
    let symbols: [String]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(Array(symbols.enumerated()), id: \.offset) { _, sym in
                Text(sym).font(.system(size: 11, weight: .semibold)).foregroundColor(.gray).frame(maxWidth: .infinity)
            }
        }
    }
}
