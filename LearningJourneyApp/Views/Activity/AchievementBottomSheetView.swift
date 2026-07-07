//
//  AchievementBottomSheetView.swift
//  LearningJourneyApp
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - AchievementBottomSheetView

struct AchievementBottomSheetView: View {
    @Environment(\.dismiss) var dismiss
    let onNavigateToUpdateGoal: () -> Void
    let onContinueSameGoal: () -> Void

    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            Image(systemName: "hands.and.sparkles.fill").resizable().scaledToFit().frame(width: 70, height: 70).foregroundColor(Color("AccentOrange")).padding(.bottom, 10)
            Text("Well done!").font(.system(size: 28, weight: .bold)).foregroundColor(.white).padding(.top, -10)
            Text("Goal completed! start learning again or\nset new learning goal").font(.system(size: 16)).foregroundColor(Color.gray.opacity(0.8)).multilineTextAlignment(.center).padding(.horizontal)
            Spacer()

            Button(action: {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { onNavigateToUpdateGoal() }
            }) {
                Text("Set new learning goal").font(.system(size: 18, weight: .medium)).foregroundColor(.white)
                    .frame(width: 246, height: 48).background(RoundedRectangle(cornerRadius: 24).fill(Color("AccentOrange")))
            }

            Button(action: {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { onContinueSameGoal() }
            }) {
                Text("Set same learning goal and duration").font(.system(size: 16, weight: .regular)).foregroundColor(Color("AccentOrange"))
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.black)
    }
}
