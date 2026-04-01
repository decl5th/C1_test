//
//  MentorListRow.swift
//  C1_test
//
//  Created by Mason's Mac on 3/30/26.
//
import SwiftUI

struct MentorsListRow: View {
    var mentor: Mentor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(mentor.mentorName)
                .foregroundColor(.primary)
                .font(.headline)
            
            Text(mentor.mentorAvailable)
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
    }
}
