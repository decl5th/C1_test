//
//  MentoringStatusView.swift
//  C1_test
//
//  Created by Mason's Mac on 4/1/26.
//

import SwiftUI
import SwiftData

struct MentoringStatusView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \schedulingRecords.selectedTime) private var mentoringRecords: [schedulingRecords]
    
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
                                   
                                   if !mentoringRecords.isEmpty {
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
                               
                
                if mentoringRecords.isEmpty {
                    EmptyMentoringView {
                        goToScheduling = true
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(mentoringRecords) { item in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("멘토: \(item.selectedMentor)")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    Text("예약 날짜: \(item.selectedTime.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color.accentColor.opacity(0.15))
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
    }
    
    private func deleteAllMentoringData() {
        for record in mentoringRecords {
            modelContext.delete(record)
        }

        try? modelContext.save()
    }
}

#Preview {
    NavigationStack {
        MentoringStatusView()
    }
    .modelContainer(InitialMentorData.previewContainer)
}
