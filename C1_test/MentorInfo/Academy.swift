import Foundation
import SwiftData

@Model
final class Expertise {
    @Attribute(.unique) var id: UUID
    var expertArea: String
    var sortOrder: Int
    var academy: Academy?

    @Relationship(deleteRule: .cascade, inverse: \Mentor.expertise)
    var mentors: [Mentor]

    init(
        id: UUID = UUID(),
        expertArea: String,
        sortOrder: Int = 0,
        mentors: [Mentor] = [],
        academy: Academy? = nil
    ) {
        self.id = id
        self.expertArea = expertArea
        self.sortOrder = sortOrder
        self.mentors = mentors
        self.academy = academy
    }
}

@Model
final class Academy {
    @Attribute(.unique) var id: UUID
    var name: String

    @Relationship(deleteRule: .cascade, inverse: \Expertise.academy)
    var experts: [Expertise]

    init(
        id: UUID = UUID(),
        name: String = "Ada",
        experts: [Expertise] = []
    ) {
        self.id = id
        self.name = name
        self.experts = experts
    }
}
