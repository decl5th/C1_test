import SwiftUI

struct MentoringRecordCard: View {
    let record: schedulingRecords

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("멘토: \(record.selectedMentor)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)

                Text("예약 날짜: \(record.selectedTime.formatted(date: .abbreviated, time: .shortened))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.body.weight(.semibold))
                .foregroundStyle(Color.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.accentColor.opacity(0.15))
        )
    }
}

#Preview("Reservation Card") {
    MentoringRecordCard(
        record: schedulingRecords(
            selectedTime: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 14, hour: 15, minute: 38)) ?? Date(),
            selectedMentor: "Issac",
            qToMentor: "SwiftData를 기존 앱에 적용시키려면 어떤 식으로 구조를 변경하면 좋을까요?"
        )
    )
    .padding()
}
