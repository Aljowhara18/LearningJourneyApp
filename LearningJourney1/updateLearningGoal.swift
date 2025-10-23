//
//  updateLearningGoal.swift
//  LearningJourney1
//
//  Created by Jojo on 23/10/2025.
//
/*
import SwiftUI

// ⭐️ ملاحظة: تم نقل الـ Extensions إلى ملف Utilities.swift

// MARK: - Components (تبقى هنا)
private struct GlassyDurationButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.system(size: 16, weight: isSelected ? .semibold : .regular)).foregroundColor(isSelected ? .white : Color.gray.opacity(0.8))
                .frame(width: 80, height: 44)
                .background(RoundedRectangle(cornerRadius: 12).fill(isSelected ? Color(hex: "#FF9230") : Color.gray.opacity(0.1)))
        }
    }
}
private struct ConfirmationPopover: View {
    @Binding var showConfirmationPopover: Bool
    let onDismiss: () -> Void
    let onUpdate: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Update learning goal").font(.system(size: 18, weight: .medium)).foregroundColor(.white)
            Text("If you update now, your streak will start over.").font(.system(size: 14)).foregroundColor(.gray).multilineTextAlignment(.center)
            HStack(spacing: 20) {
                Button(action: { withAnimation { showConfirmationPopover = false; onDismiss() } }) {
                    Text("Dismiss").font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                        .frame(width: 110, height: 48).background(Color.gray.opacity(0.4)).cornerRadius(24)
                }
                Button(action: { withAnimation { showConfirmationPopover = false; onUpdate() } }) {
                    Text("Update").font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                        .frame(width: 110, height: 48).background(Color(hex: "#FF9230")).cornerRadius(24)
                }
            }
        }.padding(.vertical, 24).frame(width: 300, height: 184)
        .background(Color(hex: "#1C1C1E")).cornerRadius(18)
        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
    }
}

// MARK: - UpdateLearningGoalView

struct UpdateLearningGoalView: View {
    
    @Binding var isNavigationActive: Bool
    let onGoalUpdated: () -> Void
    
    // ربط @AppStorage مباشرة هنا لضمان التحديث التلقائي
    @AppStorage("learningTopic") private var learningTopic: String = ""
    @AppStorage("selectedDuration") private var selectedDuration: String = "Week"
    
    @State private var showConfirmationPopover = false
    @Environment(\.dismiss) var dismiss

    let durations = ["Week", "Month", "Year"]
    
    // نحتفظ بالقيم الأصلية لمعرفة ما إذا كان قد حدث تغيير
    @State private var originalTopic: String
    @State private var originalDuration: String
    
    init(isNavigationActive: Binding<Bool>, onGoalUpdated: @escaping () -> Void, currentTopic: String, currentDuration: String) {
        self._isNavigationActive = isNavigationActive
        self.onGoalUpdated = onGoalUpdated
        // يتم استخدام currentTopic و currentDuration الممررين لتهيئة القيم الأصلية
        _originalTopic = State(initialValue: currentTopic)
        _originalDuration = State(initialValue: currentDuration)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn").font(.system(size: 22, weight: .regular)).foregroundColor(.white)
                    VStack(spacing: 6) {
                        TextField("", text: $learningTopic)
                            .placeholder(when: learningTopic.isEmpty) { Text("Swift").font(.system(size: 22)).foregroundColor(Color(hex: "999999")) }
                            .font(.system(size: 22, weight: .regular)).foregroundColor(.white).padding(.vertical, 6).disableAutocorrection(true)
                        Rectangle().fill(Color.white.opacity(0.18)).frame(height: 1)
                    }
                }
                .padding(.horizontal, 24)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("I want to learn it in a").font(.system(size: 22, weight: .regular)).foregroundColor(Color(hex: "999999"))
                    HStack(spacing: 14) {
                        ForEach(durations, id: \.self) { duration in
                            GlassyDurationButton(title: duration, isSelected: selectedDuration == duration, action: { withAnimation(.easeInOut(duration: 0.18)) { selectedDuration = duration }
                            })
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .padding(.top, 40)
            
            if showConfirmationPopover {
                Color.black.opacity(0.4).ignoresSafeArea()
                
                ConfirmationPopover(showConfirmationPopover: $showConfirmationPopover, onDismiss: { }, onUpdate: resetAndUpdateGoal)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { Button(action: { dismiss() }) { Image(systemName: "chevron.left").foregroundColor(.white) } }
            ToolbarItem(placement: .principal) { Text("Learning Goal").font(.system(size: 18, weight: .semibold)).foregroundColor(.white) }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    // إذا تغير الهدف، أظهر نافذة التأكيد، وإلا فعد للخلف
                    if isGoalChanged() {
                        showConfirmationPopover = true
                    } else {
                        dismiss()
                    }
                }) {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 24)).foregroundColor(Color(hex: "#FF9230"))
                }
                .disabled(learningTopic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
    
    // MARK: - Logic (الدوال المفقودة والمطلوبة)
    
    /**
     * تتحقق مما إذا كان الهدف أو المدة قد تغيرت عن القيم الأصلية عند فتح الشاشة.
     */
    func isGoalChanged() -> Bool {
        let currentTopicTrimmed = learningTopic.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let originalTopicTrimmed = originalTopic.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        return currentTopicTrimmed != originalTopicTrimmed || selectedDuration != originalDuration
    }
    
    /**
     * تقوم بحفظ الهدف الجديد وإعادة ضبط السجل (الـ Streak) ثم تعود للشاشة السابقة.
     */
    func resetAndUpdateGoal() {
        // 1. استدعاء الدالة الممررة من LoginAsView لإعادة ضبط الـ Streak
        onGoalUpdated()
        
        // 2. تحديث القيم الأصلية لمنع ظهور نافذة التأكيد إذا ضغط المستخدم على حفظ مرة أخرى
        originalTopic = learningTopic
        originalDuration = selectedDuration
        
        // 3. العودة إلى الشاشة السابقة
        dismiss()
    }
}

// MARK: - Preview
struct UpdateLearningGoalView_Previews: PreviewProvider {
    static var previews: some View {
        // مثال للمعاينة: تمرير قيم تجريبية
        UpdateLearningGoalView(isNavigationActive: .constant(true), onGoalUpdated: {}, currentTopic: "Swift", currentDuration: "Week")
    }
}
*/
/*
import SwiftUI

// ⭐️ ملاحظة: تم نقل الـ Extensions إلى ملف Utilities.swift (يجب أن يحتوي على Color(hex:))

// MARK: - Components (الواجهات الفرعية)

private struct GlassyDurationButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : Color.gray.opacity(0.8))
                .frame(width: 80, height: 44)
                .background(RoundedRectangle(cornerRadius: 12).fill(isSelected ? Color(hex: "#FF9230") : Color.gray.opacity(0.1)))
        }
    }
}

// ✅ ConfirmationPopover (Popover المخصص بمظهر Native Alert)
private struct ConfirmationPopover: View {
    @Binding var showConfirmationPopover: Bool
    let onDismiss: () -> Void
    let onUpdate: () -> Void
    
    var body: some View {
        VStack(spacing: 0) { // تم تغيير التباعد
            
            // المحتوى
            VStack(spacing: 6) {
                Text("Update learning goal")
                    .font(.system(size: 17, weight: .semibold)) // خط نظامي
                    .foregroundColor(.white)
                
                Text("If you update now, your streak will start over.")
                    .font(.system(size: 13)) // خط نظامي
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 20)
            .padding(.bottom, 15)
            .padding(.horizontal, 20)
            
            // فاصل بين المحتوى والأزرار
            Rectangle().fill(Color.white.opacity(0.1)).frame(height: 0.5)
            
            // حاوية الأزرار (عمودية وممتدة)
            VStack(spacing: 0) {
                
                // زر Update (باللون البرتقالي المطلوب)
                Button(action: { withAnimation { showConfirmationPopover = false; onUpdate() } }) {
                    Text("Update")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(hex: "#FF9230")) // لون النص البرتقالي
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .contentShape(Rectangle())
                }
                
                // فاصل بين الزرين
                Rectangle().fill(Color.white.opacity(0.1)).frame(height: 0.5)
                
                // زر Dismiss (زر الإلغاء)
                Button(action: { withAnimation { showConfirmationPopover = false; onDismiss() } }) {
                    Text("Dismiss")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .contentShape(Rectangle())
                }
            }
        }
        // مقاسات ومظهر الـ Alert النظامي
        .frame(width: 270)
        .background(Color(hex: "#1C1C1E"))
        .cornerRadius(14)
        .shadow(radius: 0) // إزالة الظل
    }
}

// MARK: - UpdateLearningGoalView (الواجهة الرئيسية)

struct UpdateLearningGoalView: View {
    
    @Binding var isNavigationActive: Bool
    let onGoalUpdated: () -> Void
    
    // ربط @AppStorage
    @AppStorage("learningTopic") private var learningTopic: String = ""
    @AppStorage("selectedDuration") private var selectedDuration: String = "Week"
    
    @State private var showConfirmationPopover = false
    @Environment(\.dismiss) var dismiss

    let durations = ["Week", "Month", "Year"]
    
    // نحتفظ بالقيم الأصلية
    @State private var originalTopic: String
    @State private var originalDuration: String
    
    init(isNavigationActive: Binding<Bool>, onGoalUpdated: @escaping () -> Void, currentTopic: String, currentDuration: String) {
        self._isNavigationActive = isNavigationActive
        self.onGoalUpdated = onGoalUpdated
        _originalTopic = State(initialValue: currentTopic)
        _originalDuration = State(initialValue: currentDuration)
    }

    var body: some View {
        ZStack { // ZStack لاحتواء Popover فوق المحتوى
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn").font(.system(size: 22, weight: .regular)).foregroundColor(.white)
                    VStack(spacing: 6) {
                        TextField("", text: $learningTopic)
                            .placeholder(when: learningTopic.isEmpty) { Text("Swift").font(.system(size: 22)).foregroundColor(Color(hex: "999999")) }
                            .font(.system(size: 22, weight: .regular)).foregroundColor(.white).padding(.vertical, 6).disableAutocorrection(true)
                        Rectangle().fill(Color.white.opacity(0.18)).frame(height: 1)
                    }
                }
                .padding(.horizontal, 24)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("I want to learn it in a").font(.system(size: 22, weight: .regular)).foregroundColor(Color(hex: "999999"))
                    HStack(spacing: 14) {
                        ForEach(durations, id: \.self) { duration in
                            GlassyDurationButton(title: duration, isSelected: selectedDuration == duration, action: { withAnimation(.easeInOut(duration: 0.18)) { selectedDuration = duration }
                            })
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .padding(.top, 40)
            
            // منطق ظهور الـ Popover المخصص
            if showConfirmationPopover {
                Color.black.opacity(0.4).ignoresSafeArea()
                
                ConfirmationPopover(
                    showConfirmationPopover: $showConfirmationPopover,
                    onDismiss: { /* لا شيء عند الإغلاق */ },
                    onUpdate: resetAndUpdateGoal
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { Button(action: { dismiss() }) { Image(systemName: "chevron.left").foregroundColor(.white) } }
            ToolbarItem(placement: .principal) { Text("Learning Goal").font(.system(size: 18, weight: .semibold)).foregroundColor(.white) }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    // إذا تغير الهدف، أظهر الـ Popover المخصص
                    if isGoalChanged() {
                        showConfirmationPopover = true
                    } else {
                        dismiss()
                    }
                }) {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 24)).foregroundColor(Color(hex: "#FF9230"))
                }
                .disabled(learningTopic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
    
    // MARK: - Logic
    
    func isGoalChanged() -> Bool {
        let currentTopicTrimmed = learningTopic.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let originalTopicTrimmed = originalTopic.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return currentTopicTrimmed != originalTopicTrimmed || selectedDuration != originalDuration
    }
    
    func resetAndUpdateGoal() {
        onGoalUpdated()
        originalTopic = learningTopic
        originalDuration = selectedDuration
        dismiss()
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
*/

import SwiftUI

// ⭐️ ملاحظة: تم نقل الـ Extensions إلى ملف Utilities.swift

// MARK: - Components (الواجهات الفرعية)

// ✅ تم استبدال هذا المكون بالكامل بالنسخة الأكثر تعقيداً من OnboardingView
private struct GlassyDurationButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .medium)) // تم تغيير الحجم والوزن
                .foregroundColor(.white)
                .frame(width: 108, height: 48) // تم تغيير الأبعاد
                .background(
                    ZStack {
                        // Base Color/Gradient
                        if isSelected {
                            // اللون البرتقالي المختار (يمكنك تبديله لـ FF9230 إن أردت)
                            LinearGradient(gradient: Gradient(colors: [Color(hex: "B34600"), Color(hex: "B34600")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        } else {
                            // اللون الرمادي لغير المختار
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

// ConfirmationPopover (Popover المخصص بمظهر Native Alert)
private struct ConfirmationPopover: View {
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
                        .foregroundColor(Color(hex: "#FF9230"))
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
        .background(Color(hex: "#1C1C1E"))
        .cornerRadius(14)
        .shadow(radius: 0)
    }
}

// MARK: - UpdateLearningGoalView (الواجهة الرئيسية)

struct UpdateLearningGoalView: View {
    
    @Binding var isNavigationActive: Bool
    let onGoalUpdated: () -> Void
    
    @AppStorage("learningTopic") private var learningTopic: String = ""
    @AppStorage("selectedDuration") private var selectedDuration: String = "Week"
    
    @State private var showConfirmationPopover = false
    @Environment(\.dismiss) var dismiss

    let durations = ["Week", "Month", "Year"]
    
    @State private var originalTopic: String
    @State private var originalDuration: String
    
    init(isNavigationActive: Binding<Bool>, onGoalUpdated: @escaping () -> Void, currentTopic: String, currentDuration: String) {
        self._isNavigationActive = isNavigationActive
        self.onGoalUpdated = onGoalUpdated
        _originalTopic = State(initialValue: currentTopic)
        _originalDuration = State(initialValue: currentDuration)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                // التنسيق هنا يبقى كما هو
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn").font(.system(size: 22, weight: .regular)).foregroundColor(.white)
                    VStack(spacing: 6) {
                        TextField("", text: $learningTopic)
                            .placeholder(when: learningTopic.isEmpty) { Text("Swift").font(.system(size: 22)).foregroundColor(Color(hex: "999999")) }
                            .font(.system(size: 22, weight: .regular)).foregroundColor(.white).padding(.vertical, 6).disableAutocorrection(true)
                        Rectangle().fill(Color.white.opacity(0.18)).frame(height: 1)
                    }
                }
                .padding(.horizontal, 24)
                
                // ✅ يتم استخدام GlassyDurationButton الجديد هنا
                VStack(alignment: .leading, spacing: 12) {
                    Text("I want to learn it in a").font(.system(size: 22, weight: .regular)).foregroundColor(Color(hex: "999999"))
                    HStack(spacing: 14) {
                        ForEach(durations, id: \.self) { duration in
                            GlassyDurationButton(title: duration, isSelected: selectedDuration == duration, action: { withAnimation(.easeInOut(duration: 0.18)) { selectedDuration = duration }
                            })
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .padding(.top, 40)
            
            // منطق ظهور الـ Popover المخصص
            if showConfirmationPopover {
                Color.black.opacity(0.4).ignoresSafeArea()
                
                ConfirmationPopover(
                    showConfirmationPopover: $showConfirmationPopover,
                    onDismiss: { /* لا شيء عند الإغلاق */ },
                    onUpdate: resetAndUpdateGoal
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { Button(action: { dismiss() }) { Image(systemName: "chevron.left").foregroundColor(.white) } }
            ToolbarItem(placement: .principal) { Text("Learning Goal").font(.system(size: 18, weight: .semibold)).foregroundColor(.white) }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if isGoalChanged() {
                        showConfirmationPopover = true
                    } else {
                        dismiss()
                    }
                }) {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 24)).foregroundColor(Color(hex: "#FF9230"))
                }
                .disabled(learningTopic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
    
    // MARK: - Logic
    
    func isGoalChanged() -> Bool {
        let currentTopicTrimmed = learningTopic.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let originalTopicTrimmed = originalTopic.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return currentTopicTrimmed != originalTopicTrimmed || selectedDuration != originalDuration
    }
    
    func resetAndUpdateGoal() {
        onGoalUpdated()
        originalTopic = learningTopic
        originalDuration = selectedDuration
        dismiss()
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
