//
//  RootView.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - RootView

struct RootView: View {
    @AppStorage("learningTopic") private var learningTopic: String = ""

    var body: some View {
        NavigationStack {
            if learningTopic.isEmpty {
                OnboardingView(onGoalSet: { })
                    .navigationBarBackButtonHidden(true)
            } else {
                LoginAsView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
