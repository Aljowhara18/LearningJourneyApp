//
//  DayCellView.swift
//  LearningJourneyApp
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - DayCellView

struct DayCellView: View {
    let dayNumber: Int
    let status: String?
    let isToday: Bool

    var body: some View {
        ZStack {
            if status == "learned" {
                Circle().fill(Color("LearnedBrown")).frame(width: 34, height: 34)
            } else if status == "freezed" {
                Circle().fill(Color("FreezedBlue")).frame(width: 34, height: 34)
            } else if isToday {
                Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1).frame(width: 34, height: 34)
            } else {
                Circle().fill(Color.black.opacity(0.18)).frame(width: 34, height: 34)
            }
            Text("\(dayNumber)").font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
        }
    }
}
