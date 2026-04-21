//
//  SubView.swift
//  C1_test
//
//  Created by Mason's Mac on 3/22/26.
//

import SwiftUI
import SwiftData

struct SchedulingView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedMentorName: Mentor? = nil
    @State private var isMentorListPresented: Bool = false
    @State private var mentoringDate = Date()
    @State private var fullText: String = ""
    @State private var keyboardHeight: CGFloat = 0
    @State private var showMentorRequired = false
    @FocusState private var isQuestionEditorFocused: Bool
    
    @State private var popUp = false // 신청 후 팝업 메시지
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    let backgroundCover = Color.backgroundApp
    private let questionPlaceholder = "멘토에게 궁금한 질문이 있다면 여기에 남겨주세요"
    private let cardCornerRadius: CGFloat = 20
    private let cardFillColor = Color.white.opacity(0.82)
    private let defaultCardBorderColor = Color.accentColor.opacity(0.35)

    private var trimmedQuestion: String {
        fullText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var mentorCardBorderColor: Color {
        showMentorRequired && selectedMentorName == nil ? .red : defaultCardBorderColor
    }

    private var minimumSchedulableDate: Date {
        SchedulingTimePolicy.minimumDate()
    }
    
    private func schedulingSave() {
        guard let selectedMentorName else {
            return
        }

        let record = schedulingRecords(
            selectedTime: mentoringDate,
            selectedMentor: selectedMentorName.mentorName,
            qToMentor: trimmedQuestion
        )

        modelContext.insert(record)
        try? modelContext.save()
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottom) {
                
                backgroundCover
                    .ignoresSafeArea(edges: .all)
                
                ScrollView {
                    VStack(spacing: 16) {
                        Text("새로운 멘토링")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)

                        VStack(alignment: .leading, spacing: 12) {
                            DatePicker(
                                "날짜",
                                selection: $mentoringDate,
                                in: Date()...,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)

                            Divider()

                            HStack {
                                Text("시간")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)

                                Spacer()

                                HalfHourTimePicker(
                                    selection: $mentoringDate,
                                    minimumDate: minimumSchedulableDate
                                )
                                    .frame(width: 120, height: 36)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            if showMentorRequired && selectedMentorName == nil {
                                Text("(required)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 4)
                            }

                            Button {
                                isMentorListPresented = true
                            } label: {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Mentors")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.primary)

                                        Spacer()
                                    }
                                    
                                    if let selectedMentorName {
                                        Text(selectedMentorName.mentorName)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.accentColor)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    } else {
                                        Text("멘토를 선택해주세요")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.secondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous)
                                        .fill(cardFillColor)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous)
                                        .stroke(mentorCardBorderColor, lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .id("mentorSelector")

                        VStack(alignment: .leading, spacing: 12) {
                            Text("사전 질의")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)

                            ZStack(alignment: .topLeading) {
                                if fullText.isEmpty {
                                Text(questionPlaceholder)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 12)
                                }

                                TextEditor(text: $fullText)
                                    .focused($isQuestionEditorFocused)
                                    .scrollContentBackground(.hidden)
                                    .foregroundColor(.black)
                                    .font(.custom("HelveticaNeue", size: 13))
                                    .lineSpacing(5)
                                    .frame(minHeight: 120)
                                    .textEditorStyle(.automatic)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous)
                                .fill(cardFillColor)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous)
                                .stroke(defaultCardBorderColor, lineWidth: 1)
                        )
                        .id("questionEditor")
                    }
                    .padding()
                    .padding(.bottom, max(keyboardHeight, 112))
                    .safeAreaPadding(.top, 12)
                }
                .scrollDismissesKeyboard(.interactively)

                submitButton(proxy: proxy)
            }
            .animation(.easeOut(duration: 0.2), value: keyboardHeight)
            .onChange(of: isQuestionEditorFocused) { _, isFocused in
                guard isFocused else { return }

                withAnimation(.easeInOut(duration: 0.25)) {
                    proxy.scrollTo("questionEditor", anchor: .center)
                }
            }
            .sheet(isPresented: $isMentorListPresented) {
                NavigationStack {
                    MentorsList(selectedMentorName: $selectedMentorName)
                }
            }
            .onAppear {
                mentoringDate = SchedulingTimePolicy.normalize(
                    mentoringDate,
                    now: Date()
                )
            }
            .onChange(of: mentoringDate) { _, newValue in
                let normalizedDate = SchedulingTimePolicy.normalize(
                    newValue,
                    now: Date()
                )

                if normalizedDate != newValue {
                    mentoringDate = normalizedDate
                }
            }
            .onChange(of: selectedMentorName) { _, newValue in
                if newValue != nil {
                    showMentorRequired = false
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { notification in
                updateKeyboardHeight(from: notification)
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardHeight = 0
            }
        }
    }

    private func updateKeyboardHeight(from notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }

        keyboardHeight = max(keyboardFrame.height - 24, 0)
    }

    @ViewBuilder
    private func submitButton(proxy: ScrollViewProxy) -> some View {
        VStack(spacing: 0) {
            Spacer()

            Button {
                if selectedMentorName == nil {
                    showMentorRequired = true
                    withAnimation(.easeInOut(duration: 0.25)) {
                        proxy.scrollTo("mentorSelector", anchor: .center)
                    }
                } else {
                    schedulingSave()
                    popUp = true
                }
            } label: {
                Text("신청")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, max(keyboardHeight, 16))
            .background(
                LinearGradient(
                    colors: [Color.backgroundApp.opacity(0), Color.backgroundApp.opacity(0.94)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .alert("예약신청완료", isPresented: $popUp) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            }
        }
    }

}

#Preview("Scheduling") {
    SchedulingView()
        .modelContainer(InitialMentorData.previewContainer)
}

//#Preview("Mentor List") {
//    NavigationStack {
//        MentorsList(selectedMentorName: .constant(nil))
//    }
//    .modelContainer(InitialMentorData.previewContainer)
//}
