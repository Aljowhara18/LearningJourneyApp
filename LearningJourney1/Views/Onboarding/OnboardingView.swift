//
//  OnboardingView.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - OnboardingView

struct OnboardingView: View {

    @StateObject private var viewModel = OnboardingViewModel()
    let onGoalSet: () -> Void

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 28) {

                    Spacer().frame(height: 36)

                    // MARK: - App Icon
                    ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color("OnboardingIconTop"), Color("OnboardingIconBottom")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 109, height: 109)
                            .overlay(Circle().stroke(Color("IconBorderGray"), lineWidth: 1))
                            .shadow(color: Color.black.opacity(0.6), radius: 8, x: 0, y: 4)

                        Image(systemName: "flame.fill")
                            .resizable().scaledToFit().frame(width: 48, height: 48)
                            .foregroundColor(Color("AccentOrange"))
                    }

                    // MARK: - Greeting
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Hello Learner 👋")
                            .font(.system(size: 34, weight: .bold)).foregroundColor(.white).padding(.top, 52)
                        Text("This app will help you learn everyday!")
                            .font(.system(size: 17, weight: .regular)).foregroundColor(Color("SecondaryTextGray"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 24)

                    // MARK: - Input Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("I want to learn").font(.system(size: 22, weight: .regular)).foregroundColor(.white)
                        VStack(spacing: 6) {
                            TextField("", text: $viewModel.learningTopic)
                                .placeholder(when: viewModel.learningTopic.isEmpty) {
                                    Text("Swift").font(.system(size: 22)).foregroundColor(Color("SecondaryTextGray"))
                                }
                                .font(.system(size: 22, weight: .regular)).foregroundColor(.white).padding(.vertical, 6).disableAutocorrection(true)
                            Rectangle().fill(Color.white.opacity(0.18)).frame(height: 1)
                        }
                    }
                    .padding(.horizontal, 24)

                    // MARK: - Duration Picker
                    VStack(alignment: .leading, spacing: 12) {
                        Text("I want to learn it in a").font(.system(size: 22, weight: .regular)).foregroundColor(Color("SecondaryTextGray"))
                        HStack(spacing: 14) {
                            ForEach(viewModel.durations, id: \.self) { duration in
                                GlassyDurationButton(title: duration,
                                                     isSelected: viewModel.selectedDuration == duration,
                                                     action: { withAnimation(.easeInOut(duration: 0.18)) { viewModel.selectedDuration = duration } })
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer().frame(height: 124)

                    // MARK: - Start Button
                    Button(action: {
                        if viewModel.canStart {
                            viewModel.startLearning()
                            onGoalSet()
                        } else {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    }) {
                        Text("Start learning")
                            .font(.system(size: 18, weight: .medium)).foregroundColor(.white)
                            .frame(width: 182, height: 48)
                            .background(
                                ZStack {
                                    LinearGradient(gradient: Gradient(colors: [Color("AccentOrange"), Color("AccentOrange")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.22), Color.white.opacity(0.02)]), startPoint: .top, endPoint: .center)
                                        .blendMode(.overlay)
                                        .mask(RoundedRectangle(cornerRadius: 28).frame(height: 54))
                                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.08)]), startPoint: .center, endPoint: .bottom)
                                        .blendMode(.multiply)
                                }
                            )
                            .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.white.opacity(0.22), lineWidth: 1).blendMode(.overlay))
                            .cornerRadius(28)
                            .shadow(color: Color.black.opacity(0.6), radius: 8, x: 0, y: 8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 36)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView(onGoalSet: {})
}
