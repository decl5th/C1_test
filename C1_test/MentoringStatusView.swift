//
//  MentoringStatusView.swift
//  C1_test
//
//  Created by Mason's Mac on 4/1/26.
//

import SwiftUI

struct MentoringStatusView: View {
    
    @State private var savedDates: [Date] = []
    @State private var savedMentorNames: [String] = []
    @State private var savedTexts: [String] = []
    
    @State private var goToScheduling = false
    
    var body: some View {
        ZStack {
            Color.backgroundApp
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 16) {
                
                HStack(alignment: .center) {
                                   Text("나의 멘토링")
                                       .font(.largeTitle)
                                       .fontWeight(.bold)
                                       .foregroundStyle(.black)
                                   
                                   Spacer()
                                   
                                   if !mentoringItems.isEmpty {
                                       Button {
                                           deleteAllMentoringData()
                                       } label: {
                                           Text("내역 삭제")
                                               .font(.subheadline)
                                               .fontWeight(.semibold)
                                               .foregroundStyle(.secondary)
                                       }
                                       .buttonStyle(.plain)
                                   }
                               }
                               .padding(.horizontal)
                               .padding(.top, 8)
                               
                
                if mentoringItems.isEmpty {
                    EmptyMentoringView {
                        goToScheduling = true
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(mentoringItems.enumerated()), id: \.offset) { index, item in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("멘토: \(item.loadMentorName)")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    Text("예약 날짜: \(item.date.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color(.accent.opacity(0.15)))
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    
                        
                        NavigationLink {
                            SchedulingView()
                        } label: {
                            Text("멘토링 신청하기")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    
                }
                
                NavigationLink(destination: SchedulingView(), isActive: $goToScheduling) {
                    EmptyView()
                }
            }
            .padding(.top, 8)
        }
        .navigationBarHidden(true)
        .onAppear {
            loadData()
        }
    }
    
    var mentoringItems: [(loadMentorName: String, date: Date)] {
        let count = min(savedMentorNames.count, savedDates.count)
        return (0..<count).map { index in
            (loadMentorName: savedMentorNames[index], date: savedDates[index])
        }
    }
    
    private func loadData() {
        savedDates = UserDefaults.standard.array(forKey: "mentoringDate") as? [Date] ?? []
        savedMentorNames = UserDefaults.standard.stringArray(forKey: "selectedMentorName") ?? []
        savedTexts = UserDefaults.standard.stringArray(forKey: "fullText") ?? []
    }
    
    private func deleteAllMentoringData() {
        UserDefaults.standard.removeObject(forKey: "mentoringDate")
        UserDefaults.standard.removeObject(forKey: "selectedMentorName")
        UserDefaults.standard.removeObject(forKey: "fullText")
        
        savedDates = []
        savedMentorNames = []
        savedTexts = []
    }
}

#Preview {
    NavigationStack {
        MentoringStatusView()
    }
}
