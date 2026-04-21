//
//  SubView.swift
//  C1_test
//
//  Created by Mason's Mac on 3/22/26.
//

import SwiftUI
import SwiftData

struct SchedulingView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedMentorName: Mentor? = nil
    @State private var isMentorListPresented: Bool = false
    @State private var mentoringDate = Date()
    @State private var fullText: String = "멘토에게 궁금한 질문이 있다면 여기에 남겨주세요"
    
    @State private var popUp = false // 신청 후 팝업 메시지
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    let backgroundCover = Color.backgroundApp
    
    private func schedulingSave() {
        let record = schedulingRecords(
            selectedTime: mentoringDate,
            selectedMentor: selectedMentorName?.mentorName ?? "멘토 미선택",
            qToMentor: fullText
        )

        modelContext.insert(record)
        try? modelContext.save()
    }
    
    var body: some View {
        ZStack {
            
            backgroundCover
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 16) {
                Text("새로운 멘토링")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)

                
                
                DatePicker(
                    "Start Date",
                    selection: $mentoringDate,
                    in: Date()...
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(maxWidth: 400)
                
                // Text("Mentoring is \(mentoringDate, formatter: dateFormatter)")
                    
                    Button {
                        isMentorListPresented = true
                    } label: {
                        ZStack {
                            HStack {
                                Text("Mentors")
                                    .font(.headline)
                                    .foregroundStyle(.black)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 14)
                            
                            if let selectedMentorName {
                                Text(selectedMentorName.mentorName)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.accentColor)
                                    .multilineTextAlignment(.center)
                            } else {
                                Text("멘토를 선택해주세요")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(height: 56)
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.accentColor, lineWidth: 0.4)
                        }
                    }
                    .buttonStyle(.plain)
                
                
                
                TextEditor(text: $fullText)
                    .scrollContentBackground(.hidden)
                    .foregroundColor(Color.black)
                    .font(.custom("HelveticaNeue", size: 13))
                    .lineSpacing(5)
                    .textEditorStyle(.automatic)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.accentColor, lineWidth: 0.4)
                    }
                
                HStack{
                    
                    Spacer()
                    Button {
                        schedulingSave()
                        popUp = true
                        
                    }
                    
                    label: {
                        Text("신청")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.glassProminent)
                    .frame(alignment: .bottomTrailing)
                                    
                    
                    .alert("예약신청완료", isPresented: $popUp) {
                        Button("OK", role: .cancel) {
                            print("확인")
                            dismiss()
                        }
                    }
                }
                
            }
            .padding()
            .sheet(isPresented: $isMentorListPresented) {
                NavigationStack {
                    MentorsList(selectedMentorName: $selectedMentorName)
                }
            }
            // .background(.tint)
            
        }
    }

}

#Preview("Scheduling") {
    SchedulingView()
        .modelContainer(InitialMentorData.previewContainer)
}

//#Preview("Mentor List") {
//    NavigationStack {
//        MentorsList(selectedMentorName: .constant(nil))
//    }
//    .modelContainer(InitialMentorData.previewContainer)
//}
