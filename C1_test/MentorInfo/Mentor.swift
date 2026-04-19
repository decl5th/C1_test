//
//  Mentor.swift
//  C1_test
//
//  Created by Mason's Mac on 3/30/26.
//
import Foundation
import SwiftData

@Model
final class Mentor {
    @Attribute(.unique) var id: UUID
    var mentorName: String
    var mentorAvailable: String
    var sortOrder: Int
    var expertise: Expertise?

    init(
        id: UUID = UUID(),
        mentorName: String,
        mentorAvailable: String = "",
        sortOrder: Int = 0,
        expertise: Expertise? = nil
    ) {
        self.id = id
        self.mentorName = mentorName
        self.mentorAvailable = mentorAvailable
        self.sortOrder = sortOrder
        self.expertise = expertise
    }
}
