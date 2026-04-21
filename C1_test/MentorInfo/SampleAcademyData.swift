import Foundation
import SwiftData

enum InitialMentorData {
    static let academyName = "Ada"

    static let expertises: [(area: String, mentors: [String])] = [
        (
            area: "Tech",
            mentors: [
                "Issac",
                "Jaesung",
                "Jason",
                "Howard",
                "Rumi",
                "Nathan",
                "Lingo",
                "Judy",
                "Leeo",
                "Jett"
            ]
        ),
        (
            area: "Design",
            mentors: [
                "Jiku",
                "Dora",
                "Friday",
                "Saya",
                "Senny"
            ]
        )
    ]

    static func makeAcademy() -> Academy {
        Academy(
            name: academyName,
            experts: expertises.enumerated().map { expertiseIndex, expertise in
                Expertise(
                    expertArea: expertise.area,
                    sortOrder: expertiseIndex,
                    mentors: expertise.mentors.enumerated().map { mentorIndex, mentorName in
                        Mentor(
                            mentorName: mentorName,
                            sortOrder: mentorIndex
                        )
                    }
                )
            }
        )
    }

    @MainActor
    static func seedIfNeeded(in modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Academy>(
            predicate: #Predicate { academy in
                academy.name == academyName
            }
        )

        guard let count = try? modelContext.fetchCount(descriptor), count == 0 else {
            return
        }

        modelContext.insert(makeAcademy())
        try? modelContext.save()
    }

    static let previewReservations: [(mentor: String, selectedTime: Date, question: String)] = [
        (
            mentor: "Issac",
            selectedTime: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 14, hour: 15, minute: 38)) ?? Date(),
            question: "SwiftData를 기존 앱에 적용시키려면 어떤 식으로 구조를 변경하면 좋을까요?"
        ),
        (
            mentor: "Jiku",
            selectedTime: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 22, hour: 13, minute: 30)) ?? Date(),
            question: "디자인 시스템을 조금 더 일관되게 정리하려면 어떤 순서로 접근하면 좋을까요?"
        ),
        (
            mentor: "Jaesung",
            selectedTime: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 29, hour: 11, minute: 0)) ?? Date(),
            question: "예약 상세 화면에서 수정과 삭제를 함께 제공할 때 어떤 UX가 제일 자연스러울까요?"
        )
    ]

    @MainActor
    static func seedPreviewReservationsIfNeeded(in modelContext: ModelContext) {
        guard let count = try? modelContext.fetchCount(FetchDescriptor<schedulingRecords>()), count == 0 else {
            return
        }

        previewReservations.forEach { reservation in
            modelContext.insert(
                schedulingRecords(
                    selectedTime: reservation.selectedTime,
                    selectedMentor: reservation.mentor,
                    qToMentor: reservation.question
                )
            )
        }

        try? modelContext.save()
    }

    @MainActor
    static let previewContainer: ModelContainer = {
        do {
            let schema = Schema([
                Academy.self,
                Expertise.self,
                Mentor.self,
                schedulingRecords.self
            ])
            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true
            )
            let container = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )

            seedIfNeeded(in: container.mainContext)
            seedPreviewReservationsIfNeeded(in: container.mainContext)
            return container
        } catch {
            fatalError("Failed to create preview model container: \(error)")
        }
    }()
}
