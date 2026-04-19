//
//  ContentView.swift
//  C1_test
//
//  Created by Mason's Mac on 3/21/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            MentoringStatusView()
        }
        .task {
            InitialMentorData.seedIfNeeded(in: modelContext)
        }
    }
}

#Preview("Content") {
    ContentView()
        .modelContainer(InitialMentorData.previewContainer)
}
