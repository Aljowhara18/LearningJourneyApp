//
//  Onboarding.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//
import SwiftUI

// ⭐️ ملاحظة: تم نقل الـ Extensions إلى ملف Utilities.swift

// MARK: - Glassy Duration Button
private struct GlassyDurationButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 108, height: 48)
                .background(
                    ZStack {
                        // Base Color/Gradient
                        if isSelected {
                            LinearGradient(gradient: Gradient(colors: [Color(hex: "B34600"), Color(hex: "B34600")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        } else {
                            LinearGradient(gradient: Gradient(colors: [Color(hex: "5a5a5a"), Color(hex: "2b2b2b")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        }
                        
                        // top glossy band
                        LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.22), Color.white.opacity(0.02)]), startPoint: .top, endPoint: .center)
                            .blendMode(.overlay)
                        
                        // subtle inner shadow at bottom edge
                        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.12)]), startPoint: .center, endPoint: .bottom)
                            .blendMode(.multiply)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                        .blendMode(.overlay)
                )
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.7), radius: 8, x: 0, y: 8)
        }
    }
}


// MARK: - OnboardingView
struct OnboardingView: View {
    
    @AppStorage("learningTopic") private var appStorageLearningTopic: String = ""
    @AppStorage("selectedDuration") private var appStorageSelectedDuration: String = "Week"
    
    @State private var localLearningTopic: String = ""
    @State private var localSelectedDuration: String = "Week"
    
    let onGoalSet: () -> Void
    
    let durations = ["Week", "Month", "Year"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 28) {
                    
                    Spacer().frame(height: 36)
                    
                    // MARK: - App Icon
                    ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "613814"), Color(hex: "2a150f")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 109, height: 109)
                            .overlay(Circle().stroke(Color(hex: "979797"), lineWidth: 1))
                            .shadow(color: Color.black.opacity(0.6), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "flame.fill")
                            .resizable().scaledToFit().frame(width: 48, height: 48)
                            .foregroundColor(Color(hex: "FF9230"))
                    }
                    
                    // MARK: - Greeting
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Hello Learner 👋")
                            .font(.system(size: 34, weight: .bold)).foregroundColor(.white).padding(.top, 52)
                        Text("This app will help you learn everyday!")
                            .font(.system(size: 17, weight: .regular)).foregroundColor(Color(hex: "999999"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 24)
                    
                    // MARK: - Input Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("I want to learn").font(.system(size: 22, weight: .regular)).foregroundColor(.white)
                        VStack(spacing: 6) {
                            TextField("", text: $localLearningTopic)
                                .placeholder(when: localLearningTopic.isEmpty) {
                                    Text("Swift").font(.system(size: 22)).foregroundColor(Color(hex: "999999"))
                                }
                                .font(.system(size: 22, weight: .regular)).foregroundColor(.white).padding(.vertical, 6).disableAutocorrection(true)
                            Rectangle().fill(Color.white.opacity(0.18)).frame(height: 1)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // MARK: - Duration Picker
                    VStack(alignment: .leading, spacing: 12) {
                        Text("I want to learn it in a").font(.system(size: 22, weight: .regular)).foregroundColor(Color(hex: "999999"))
                        HStack(spacing: 14) {
                            ForEach(durations, id: \.self) { duration in
                                GlassyDurationButton(title: duration,
                                                     isSelected: localSelectedDuration == duration,
                                                     action: { withAnimation(.easeInOut(duration: 0.18)) { localSelectedDuration = duration } })
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer().frame(height: 124)
                    
                    // MARK: - Start Button
                    Button(action: {
                        if !localLearningTopic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            appStorageLearningTopic = localLearningTopic
                            appStorageSelectedDuration = localSelectedDuration
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
                                    LinearGradient(gradient: Gradient(colors: [Color(hex: "FF9230"), Color(hex: "FF9230")]), startPoint: .topLeading, endPoint: .bottomTrailing)
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
            .onAppear {
                if !appStorageLearningTopic.isEmpty {
                    localLearningTopic = appStorageLearningTopic
                    localSelectedDuration = appStorageSelectedDuration
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
