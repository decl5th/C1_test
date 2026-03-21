//
//  HomeView.swift
//  C1_test
//
//  Created by Mason's Mac on 3/22/26.
//

import SwiftUI
// branch split homescreen 작업 후 subview branch 생성 예정
struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Home Screen")
                .font(.largeTitle)

            NavigationLink("Go to Detail") {
                SubView()
            }
        }
        .padding()
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
