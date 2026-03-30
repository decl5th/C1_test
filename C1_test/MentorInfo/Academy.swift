import Foundation

struct Expertise: Identifiable {
    let id = UUID()
    var expertArea: String
    var mentors: [Mentor]
}

struct Ada {
    var experts: [Expertise]
}

