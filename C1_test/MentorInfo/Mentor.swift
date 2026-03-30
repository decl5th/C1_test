//
//  Mentor.swift
//  C1_test
//
//  Created by Mason's Mac on 3/30/26.
//
import Foundation

struct Mentor: Identifiable, Hashable {
    let id = UUID()
    var mentorName: String
    var mentorAvailable: String
}
