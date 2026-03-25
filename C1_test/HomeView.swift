//
//  HomeView.swift
//  C1_test
//
//  Created by Mason's Mac on 3/22/26.
//

import SwiftUI
// branch split homescreen 작업 후 subview branch 생성 예정

struct Mentoring: Identifiable {
  let mentorName: String
  let mentoringDate: String
  let mentoringTime: String
  let id = UUID()
  
  
  var fullName: String { mentorName }
}

struct HomeView: View {
    
    @State private var mentors = [
        Mentoring(mentorName: "아이작", mentoringDate: "3/28", mentoringTime: "10:00"),
        Mentoring(mentorName: "지쿠", mentoringDate: "3/30", mentoringTime: "13:00")
     ]
    
    @State private var sortOrderBy = [KeyPathComparator(\Mentoring.mentorName)]
     
#if os(iOS)
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  private var isCompact: Bool { horizontalSizeClass == .compact }
  #else
  private let isCompact = false
#endif
    
    var body: some View {
        VStack(spacing: 20) {
            
            Table(mentors, sortOrder: $sortOrderBy){
                TableColumn("Mentor", value: \.mentorName) { mentors in
                    VStack(alignment: .leading) {
                        Text(isCompact ? mentors.fullName : mentors.mentorName)
                        if isCompact{
                            Text(mentors.mentoringDate)
                                
                            Text(mentors.mentoringTime)
                                
                        }
                    }
                }
                TableColumn("Date", value: \.mentoringDate)
                TableColumn("Time", value: \.mentoringTime)
            }
            .onChange(of: sortOrderBy){
                _, sortOrderBy in
                mentors.sort(using: sortOrderBy)
            }

            NavigationLink("멘토링 신청하기") {
                SchedulingView()
            }
        }
        .padding()
        .navigationTitle("나의 멘토링")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
