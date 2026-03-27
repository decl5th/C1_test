//
//  SubView.swift
//  C1_test
//
//  Created by Mason's Mac on 3/22/26.
//

import SwiftUI

struct Mentors : Identifiable {
    var id: Int
    var mentorName: String
    var mentorAvailable: Bool
  
    subscript(key: String) -> Int{
        switch key {
        case "id" :
            return id
        default :
            return 0
        }
    }
}

let mentor: [Mentors] = [
    Mentors(id:1, mentorName: "아이작", mentorAvailable: true),
    Mentors(id:2, mentorName: "지쿠", mentorAvailable: true),
    Mentors(id:3, mentorName: "MK", mentorAvailable: false)
]

struct MentorList: View {
    var body: some View {
        List {
            VStack {
                ForEach(mentor, id: \.id) { mentor in
                    HStack{
                        Text(mentor.mentorName)
                    }
                }
            }
        }
    }
}

struct SchedulingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isMentorListPresented: Bool = false
    @State private var mentoringDate = Date()
    @State private var fullText: String = "This is some editable text..."
    
    /*
     @State private var availableMentor = [
        Mentors(mentorName: "아이작", mentorAvailable: true),
        Mentors(mentorName: "지쿠", mentorAvailable: true),
        Mentors(mentorName: "MK", mentorAvailable: false)
     ]
     */
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    
    var body: some View {
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
        
            
            Text("Mentoring is \(mentoringDate, formatter: dateFormatter)")
            
            Button {
                isMentorListPresented = true
            } label: {
                Text("Mentors")
            }
            
            
            TextEditor(text: $fullText)
                .foregroundColor(Color.black)
                .font(.custom("HelveticaNeue", size: 13))
                .lineSpacing(5)
                .textEditorStyle(.automatic)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray, lineWidth: 0.4)
                }
            HStack{
                Spacer()
                Button {
                    
                    dismiss()
                } label: {
                    Text("신청")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.glassProminent)
                .frame(alignment: .bottomTrailing)
            }
            
        }
        .padding()
        .sheet(isPresented: $isMentorListPresented) {
            MentorList()
        }
    }
}
#Preview {
    SchedulingView()
}

#Preview {
    MentorList()
}
