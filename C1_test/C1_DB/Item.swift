//
//  File.swift
//  C1_test
//
//  Created by Mason's Mac on 3/30/26.
//

import Foundation
import SwiftData


@Model
final class schedulingRecords {
    var selectedTime: Date // Datepicker에서 선택한 날짜와 시간
    var selectedMentor: String // MentorList에서 선택한 mentorName
    var qToMentor: String // TextEditor에서 입력한 String 

    init(selectedTime: Date, selectedMentor: String, qToMentor: String) {
        self.selectedTime = selectedTime
        self.selectedMentor = selectedMentor
        self.qToMentor = qToMentor
    }
}
