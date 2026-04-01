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
   // @Environment(\.modelContext) private var modelContext
    
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
    
    let blueGradient = Color(.backgroundApp)
    
    private func schedulingSave() {
        UserDefaults.standard.set(mentoringDate, forKey: "mentoringDate")
        UserDefaults.standard.set(selectedMentorName?.mentorName, forKey: "selectedMentorName")
        UserDefaults.standard.set(fullText, forKey: "fullText")
    }
    
    var body: some View {
        ZStack {
            
            blueGradient
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 16) {
                Text("새로운 멘토링")
                    .font(.title)
                
                
                DatePicker(
                    "Start Date",
                    selection: $mentoringDate,
                    in: Date()...
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(maxWidth: 400)
                
                // Text("Mentoring is \(mentoringDate, formatter: dateFormatter)")
                
                HStack{
                    Button {
                        isMentorListPresented = true
                    } label: {
                        Text("Mentors")
                        
                    }
                    .foregroundStyle(.black)
                    
                    
                    
                    if let selectedMentorName {
                        Text(selectedMentorName.mentorName)
                            .font(.headline)
                            .foregroundStyle(.accent)
                    }
                }
                
                
                TextEditor(text: $fullText)
                    .scrollContentBackground(.hidden)
                    .foregroundColor(Color.black)
                    .font(.custom("HelveticaNeue", size: 13))
                    .lineSpacing(5)
                    .textEditorStyle(.automatic)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.accent, lineWidth: 0.4)
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
                    
                    MentorsList(academy: sampleAcademy,
                                selectedMentorName: $selectedMentorName)
                
            }
            // .background(.tint)
            
        }
    }

}
/*
private func schedulingSave() {
    UserDefaults.standard.set(mentoringDate, forKey: "mentoringDate")
    UserDefaults.standard.set(selectedMentorName?.mentorName, forKey: "selectedMentorName")
    UserDefaults.standard.set(fullText, forKey: "fullText")

    
}
 */




#Preview {
    SchedulingView()
}

#Preview {
    MentorsList(academy: sampleAcademy,selectedMentorName: .constant(nil)
    )
}
