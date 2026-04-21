//
//  MentorListRow.swift
//  C1_test
//
//  Created by Mason's Mac on 3/30/26.
//
import SwiftUI

struct MentorsListRow: View {
    var mentor: Mentor
    private let primaryTextColor = Color.black.opacity(0.9)
    private let secondaryTextColor = Color.black.opacity(0.68)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(mentor.mentorName)
                .foregroundColor(primaryTextColor)
                .font(.headline)

            if !mentor.mentorAvailable.isEmpty {
                Text(mentor.mentorAvailable)
                    .foregroundColor(secondaryTextColor)
                    .font(.subheadline)
            }
        }
    }
}
