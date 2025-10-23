//
//  Root.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//

import SwiftUI

struct RootView: View {
    
    // يتحقق من قيمة learningTopic في ذاكرة التطبيق (AppStorage)
    // إذا كانت فارغة، يعني أن المستخدم لم يكمل الإعداد بعد (Onboarding)
    @AppStorage("learningTopic") private var learningTopic: String = ""

    var body: some View {
        NavigationStack {
            if learningTopic.isEmpty {
                // الحالة 1: الهدف غير مُحدد -> اعرض شاشة الإعداد
                OnboardingView(onGoalSet: {
                    // دالة فارغة، لأن OnboardingView نفسه يقوم بتحديث learningTopic
                })
                .navigationBarBackButtonHidden(true)
            } else {
                // الحالة 2: الهدف مُحدد -> اعرض شاشة النشاط الرئيسية
                LoginAsView()
            }
        }
        // تطبيق الثيم الداكن على مستوى التطبيق
        .preferredColorScheme(.dark)
    }
}

// MARK: - PREVIEW
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
