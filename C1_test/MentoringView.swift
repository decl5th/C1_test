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
    
    let  backgroundCover = Color(.backgroundApp)
    
    private func schedulingSave() {
        // 임시 배열 생성 => dateArray에 Date타입 배열 형태로 담을거야
        var dateArray: [Date] = []
        // 저장 불러오기 -> 임시배열에 저장 => dateArray라는 변수는 또 userdefaults에 있는 배열로 Date타입으로 담는용으로 취급할거야
        dateArray = UserDefaults.standard.array(forKey: "mentoringDate") as? [Date] ?? []
        // 임시 배열에 -> 내 요소 추가 => 그래서 이 배열에 내가 선택한 날짜를 담을거야
        dateArray.append(mentoringDate)
        // 임시 배열을 유저디폴트에 저장 => 유저티폴트 저장값으로 dateArray를 담을거야
        UserDefaults.standard.set(dateArray, forKey: "mentoringDate")
        
        /*
        var mentorNameArray = [Mentor?]
        mentorNameArray = UserDefaults.standard.array(forKey: "selectedMentorName") as? [Mentor?] ?? []
        mentorNameArray.append(selectedMentorName)
        UserDefaults.standard.set(mentorNameArray, forKey: "selectedMentorName")
        */
        
        var mentorNameArray: [String] = []
          mentorNameArray = UserDefaults.standard.stringArray(forKey: "selectedMentorName") ?? []
          mentorNameArray.append(selectedMentorName?.mentorName ?? "멘토 미선택")
          UserDefaults.standard.set(mentorNameArray, forKey: "selectedMentorName")
        
        
        var questionArrary : [String] = []
        questionArrary = UserDefaults.standard.array(forKey: "fullText") as? [String] ?? []
        questionArrary.append(fullText)
        UserDefaults.standard.set(questionArrary, forKey: "fullText")
        
        
        // 단수형 저장식 UserDefaults.standard.set(mentoringDate, forKey: "mentoringDate")
        //UserDefaults.standard.set(selectedMentorName?.mentorName, forKey: "selectedMentorName")
        // UserDefaults.standard.set(fullText, forKey: "fullText")
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
                                    .foregroundStyle(.accent)
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
                                .stroke(Color.accent, lineWidth: 0.4)
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
                NavigationStack {
                    MentorsList(selectedMentorName: $selectedMentorName)
                }
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
