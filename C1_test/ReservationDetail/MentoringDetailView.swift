import SwiftUI
import SwiftData

struct MentoringDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let record: schedulingRecords

    @State private var editedQuestion: String
    @State private var isEditingQuestion: Bool
    @State private var showDeleteConfirmation = false
    private let primaryTextColor = Color.black.opacity(0.9)
    private let secondaryTextColor = Color.black.opacity(0.68)

    init(record: schedulingRecords) {
        self.record = record
        _editedQuestion = State(initialValue: record.qToMentor)
        _isEditingQuestion = State(initialValue: false)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("예약 상세")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(primaryTextColor)

                VStack(alignment: .leading, spacing: 12) {
                    Text("예약 정보")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(primaryTextColor)

                    VStack(spacing: 14) {
                        infoRow(title: "멘토", value: record.selectedMentor)
                        infoRow(
                            title: "날짜",
                            value: record.selectedTime.formatted(
                                .dateTime
                                    .year()
                                    .month(.abbreviated)
                                    .day()
                            )
                        )
                        infoRow(
                            title: "시간",
                            value: record.selectedTime.formatted(
                                .dateTime
                                    .hour()
                                    .minute()
                            )
                        )
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.8))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.accentColor.opacity(0.35), lineWidth: 1)
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("사전 질의")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(primaryTextColor)

                        Spacer()

                        Button {
                            if isEditingQuestion {
                                editedQuestion = record.qToMentor
                            }
                            isEditingQuestion.toggle()
                        } label: {
                            Image(systemName: isEditingQuestion ? "xmark" : "pencil")
                                .foregroundStyle(Color.accentColor)
                        }
                        .buttonStyle(.plain)
                    }

                    Group {
                        if isEditingQuestion {
                            TextEditor(text: $editedQuestion)
                                .scrollContentBackground(.hidden)
                                .foregroundColor(primaryTextColor)
                                .frame(minHeight: 200)
                                .padding(16)
                        } else {
                            ScrollView {
                                Text(record.qToMentor)
                                    .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
                                    .foregroundStyle(primaryTextColor)
                            }
                            .padding(16)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.8))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.accentColor.opacity(0.35), lineWidth: 1)
                    )
                }

                Button {
                    saveChanges()
                } label: {
                    Text("예약 수정 완료")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background(Color.backgroundApp.ignoresSafeArea())
        .toolbar(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(primaryTextColor)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .alert("예약을 삭제할까요?", isPresented: $showDeleteConfirmation) {
            Button("취소", role: .cancel) { }
            Button("예약 삭제", role: .destructive) {
                modelContext.delete(record)
                try? modelContext.save()
                dismiss()
            }
        } message: {
            Text("삭제한 예약은 다시 복구할 수 없습니다.")
        }
    }

    private func saveChanges() {
        record.qToMentor = editedQuestion
        try? modelContext.save()
        dismiss()
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(secondaryTextColor)

            Spacer()

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(primaryTextColor)
        }
    }
}

private struct MentoringDetailPreviewHost: View {
    @Query(sort: \schedulingRecords.selectedTime) private var records: [schedulingRecords]

    var body: some View {
        NavigationStack {
            if let record = records.first {
                MentoringDetailView(record: record)
            } else {
                Text("예약 데이터가 없습니다")
            }
        }
    }
}

#Preview("Reservation Detail") {
    MentoringDetailPreviewHost()
        .modelContainer(InitialMentorData.previewContainer)
}
