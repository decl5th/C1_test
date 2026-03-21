//
//  SubView.swift
//  C1_test
//
//  Created by Mason's Mac on 3/22/26.
//

import SwiftUI

struct SubView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Detail Screen")
                .font(.title)

            Text("This is the second screen.")
        }
        .padding()
        .navigationTitle("Detail")
    }
}

#Preview {
    SubView()
}
