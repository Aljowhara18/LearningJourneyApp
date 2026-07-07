//
//  GlassyDurationButton.swift
//  LearningJourneyApp
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - GlassyDurationButton

struct GlassyDurationButton: View {
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
                        if isSelected {
                            LinearGradient(gradient: Gradient(colors: [Color("DurationSelectedBrown"), Color("DurationSelectedBrown")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        } else {
                            LinearGradient(gradient: Gradient(colors: [Color("DurationUnselectedTop"), Color("DurationUnselectedBottom")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        }

                        LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.22), Color.white.opacity(0.02)]), startPoint: .top, endPoint: .center)
                            .blendMode(.overlay)

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
