//
//  C1_testApp.swift
//  C1_test
//
//  Created by Mason's Mac on 3/21/26.
//

import SwiftUI
import SwiftData

@main
struct C1_testApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Academy.self,
            Expertise.self,
            Mentor.self,
            schedulingRecords.self
        ])
    }
}
