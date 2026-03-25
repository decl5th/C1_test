//
//  SubView.swift
//  C1_test
//
//  Created by Mason's Mac on 3/22/26.
//

import SwiftUI

struct SchedulingView: View {
    
    @State private var date = Date()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Detail Screen")
                .font(.title)
            
            DatePicker(
                "Start Date",
                selection: $date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)

            Text("This is the second screen.")
        }
        .padding()
        .navigationTitle("새로운 멘토링")
    }
}

#Preview {
    SchedulingView()
}
