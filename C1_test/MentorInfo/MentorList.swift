//
//  MentorListRow 2.swift
//  C1_test
//
//  Created by Mason's Mac on 3/30/26.
//

import SwiftUI

struct MentorsList: View {
    let academy: Ada
    
    @Binding var selectedMentorName: Mentor?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(academy.experts) { expert in
                Section(expert.expertArea) {
                    ForEach(expert.mentors) { mentor in
                        Button {
                            if selectedMentorName?.id == mentor.id {
                                selectedMentorName = nil
                            } else {
                                selectedMentorName = mentor
                            }
                        } label: {
                            HStack {
                                MentorsListRow(mentor: mentor)
                                Spacer()
                                
                                if selectedMentorName?.id == mentor.id {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
