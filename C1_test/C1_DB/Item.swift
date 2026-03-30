//
//  File.swift
//  C1_test
//
//  Created by Mason's Mac on 3/30/26.
//

import Foundation
import SwiftData


@Model
final class Item {
    var selectedTime: Date
    var selectedMentor: String
    var qToMentor: String

    init(selectedTime: Date, selectedMentor: String, qToMentor: String) {
        self.selectedTime = selectedTime
        self.selectedMentor = selectedMentor
        self.qToMentor = qToMentor
    }
}
