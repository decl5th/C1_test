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
    @State private var showDeleteAllAlert = false
    private let secondaryTextColor = Color.black.opacity(0.68)
    
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
                                           showDeleteAllAlert = true
                                       } label: {
                                           Image(systemName: "trash")
                                               .font(.body.weight(.semibold))
                                               .foregroundStyle(secondaryTextColor)
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
                                NavigationLink {
                                    MentoringDetailView(record: item)
                                } label: {
                                    MentoringRecordCard(record: item)
                                }
                                .buttonStyle(.plain)
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
            }
            .padding(.top, 8)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $goToScheduling) {
            SchedulingView()
        }
        .alert("예약 내역을 모두 삭제할까요?", isPresented: $showDeleteAllAlert) {
            Button("취소", role: .cancel) { }
            Button("전체 삭제", role: .destructive) {
                deleteAllMentoringData()
            }
        } message: {
            Text("저장된 멘토링 예약 내역이 모두 삭제되며 다시 복구할 수 없습니다.")
        }
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
