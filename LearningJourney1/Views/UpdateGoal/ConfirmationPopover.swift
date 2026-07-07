//
//  ConfirmationPopover.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

// MARK: - ConfirmationPopover

struct ConfirmationPopover: View {
    @Binding var showConfirmationPopover: Bool
    let onDismiss: () -> Void
    let onUpdate: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text("Update learning goal")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)

                Text("If you update now, your streak will start over.")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 20)
            .padding(.bottom, 15)
            .padding(.horizontal, 20)

            Rectangle().fill(Color.white.opacity(0.1)).frame(height: 0.5)

            VStack(spacing: 0) {
                Button(action: { withAnimation { showConfirmationPopover = false; onUpdate() } }) {
                    Text("Update")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color("AccentOrange"))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .contentShape(Rectangle())
                }

                Rectangle().fill(Color.white.opacity(0.1)).frame(height: 0.5)

                Button(action: { withAnimation { showConfirmationPopover = false; onDismiss() } }) {
                    Text("Dismiss")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .contentShape(Rectangle())
                }
            }
        }
        .frame(width: 270)
        .background(Color("PopoverBackground"))
        .cornerRadius(14)
        .shadow(radius: 0)
    }
}
