//
//  MentorListRow 2.swift
//  C1_test
//
//  Created by Mason's Mac on 3/30/26.
//

import SwiftUI
import SwiftData

struct MentorsList: View {
    @Binding var selectedMentorName: Mentor?
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Expertise.sortOrder) private var expertises: [Expertise]
    @State private var expandedExpertiseIDs: Set<UUID> = []

    private let collapsedMentorLimit = 3
    
    var body: some View {
        List {
            ForEach(expertises) { expert in
                Section(expert.expertArea) {
                    ForEach(visibleMentors(for: expert)) { mentor in
                        Button {
                            if selectedMentorName?.id == mentor.id {
                                selectedMentorName = nil
                            } else {
                                selectedMentorName = mentor
                                dismiss()
                            }
                        } label: {
                            HStack {
                                MentorsListRow(mentor: mentor)
                                Spacer()
                                
                                if selectedMentorName?.id == mentor.id {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.tint)
                                }
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }

                    if shouldShowExpansionButton(for: expert) {
                        Button {
                            toggleExpanded(for: expert)
                        } label: {
                            HStack {
                                Spacer()

                                Image(systemName: isExpanded(expert) ? "chevron.up" : "chevron.down")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.accent)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationTitle("멘토 선택")
    }

    private func sortedMentors(for expertise: Expertise) -> [Mentor] {
        expertise.mentors.sorted {
            let nameComparison = $0.mentorName.localizedCaseInsensitiveCompare($1.mentorName)

            if nameComparison == .orderedSame {
                return $0.sortOrder < $1.sortOrder
            }

            return nameComparison == .orderedAscending
        }
    }

    private func visibleMentors(for expertise: Expertise) -> [Mentor] {
        let mentors = sortedMentors(for: expertise)

        guard !isExpanded(expertise) else {
            return mentors
        }

        return Array(mentors.prefix(collapsedMentorLimit))
    }

    private func shouldShowExpansionButton(for expertise: Expertise) -> Bool {
        sortedMentors(for: expertise).count > collapsedMentorLimit
    }

    private func hiddenMentorCount(for expertise: Expertise) -> Int {
        max(sortedMentors(for: expertise).count - collapsedMentorLimit, 0)
    }

    private func isExpanded(_ expertise: Expertise) -> Bool {
        expandedExpertiseIDs.contains(expertise.id)
    }

    private func toggleExpanded(for expertise: Expertise) {
        if isExpanded(expertise) {
            expandedExpertiseIDs.remove(expertise.id)
        } else {
            expandedExpertiseIDs.insert(expertise.id)
        }
    }

//    private func expansionButtonTitle(for expertise: Expertise) -> String {
//        if isExpanded(expertise) {
//            " "
//        } else {
//            " "
//        }
//    }
}
