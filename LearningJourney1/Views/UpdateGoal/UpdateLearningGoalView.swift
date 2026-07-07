//
//  UpdateLearningGoalView.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - UpdateLearningGoalView

struct UpdateLearningGoalView: View {

    @StateObject private var viewModel: UpdateLearningGoalViewModel
    @Binding var isNavigationActive: Bool
    let onGoalUpdated: () -> Void
    @Environment(\.dismiss) var dismiss

    init(isNavigationActive: Binding<Bool>, onGoalUpdated: @escaping () -> Void, currentTopic: String, currentDuration: String) {
        self._isNavigationActive = isNavigationActive
        self.onGoalUpdated = onGoalUpdated
        _viewModel = StateObject(wrappedValue: UpdateLearningGoalViewModel(currentTopic: currentTopic, currentDuration: currentDuration))
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn").font(.system(size: 22, weight: .regular)).foregroundColor(.white)
                    VStack(spacing: 6) {
                        TextField("", text: $viewModel.learningTopic)
                            .placeholder(when: viewModel.learningTopic.isEmpty) { Text("Swift").font(.system(size: 22)).foregroundColor(Color("SecondaryTextGray")) }
                            .font(.system(size: 22, weight: .regular)).foregroundColor(.white).padding(.vertical, 6).disableAutocorrection(true)
                        Rectangle().fill(Color.white.opacity(0.18)).frame(height: 1)
                    }
                }
                .padding(.horizontal, 24)

                VStack(alignment: .leading, spacing: 12) {
                    Text("I want to learn it in a").font(.system(size: 22, weight: .regular)).foregroundColor(Color("SecondaryTextGray"))
                    HStack(spacing: 14) {
                        ForEach(viewModel.durations, id: \.self) { duration in
                            GlassyDurationButton(title: duration, isSelected: viewModel.selectedDuration == duration, action: { withAnimation(.easeInOut(duration: 0.18)) { viewModel.selectedDuration = duration }
                            })
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
            .padding(.top, 40)

            if viewModel.showConfirmationPopover {
                Color.black.opacity(0.4).ignoresSafeArea()

                ConfirmationPopover(
                    showConfirmationPopover: $viewModel.showConfirmationPopover,
                    onDismiss: { },
                    onUpdate: {
                        viewModel.confirmUpdate(onGoalUpdated: onGoalUpdated)
                        dismiss()
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { Button(action: { dismiss() }) { Image(systemName: "chevron.left").foregroundColor(.white) } }
            ToolbarItem(placement: .principal) { Text("Learning Goal").font(.system(size: 18, weight: .semibold)).foregroundColor(.white) }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if viewModel.isGoalChanged {
                        viewModel.showConfirmationPopover = true
                    } else {
                        dismiss()
                    }
                }) {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 24)).foregroundColor(Color("AccentOrange"))
                }
                .disabled(viewModel.isTopicEmpty)
            }
        }
    }
}

// MARK: - Preview

struct UpdateLearningGoalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UpdateLearningGoalView(isNavigationActive: .constant(true), onGoalUpdated: {}, currentTopic: "Swift", currentDuration: "Week")
        }
    }
}
