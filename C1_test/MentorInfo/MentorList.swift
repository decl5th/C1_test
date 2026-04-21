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
    private let sheetBackgroundColor = Color.backgroundApp
    private let rowBackgroundColor = Color.white.opacity(0.94)
    private let secondaryTextColor = Color.black.opacity(0.68)
    
    var body: some View {
        ZStack {
            sheetBackgroundColor
                .ignoresSafeArea()

            List { listContent }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .listStyle(.insetGrouped)
        }
        .navigationTitle("멘토 선택")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(sheetBackgroundColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .preferredColorScheme(.light)
    }

    @ViewBuilder
    private var listContent: some View {
        ForEach(expertises) { expert in
            Section {
                ForEach(visibleMentors(for: expert)) { mentor in
                    mentorButton(for: mentor)
                }

                if shouldShowExpansionButton(for: expert) {
                    expandButton(for: expert)
                }
            } header: {
                Text(expert.expertArea)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(secondaryTextColor)
            }
        }
    }

    private func mentorButton(for mentor: Mentor) -> some View {
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
        .listRowBackground(rowBackgroundColor)
    }

    private func expandButton(for expertise: Expertise) -> some View {
        Button {
            toggleExpanded(for: expertise)
        } label: {
            HStack {
                Spacer()

                Image(systemName: isExpanded(expertise) ? "chevron.up" : "chevron.down")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.accentColor)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(rowBackgroundColor)
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
}
