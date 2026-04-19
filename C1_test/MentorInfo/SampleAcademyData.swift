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
            return container
        } catch {
            fatalError("Failed to create preview model container: \(error)")
        }
    }()
}
