//
//  SubView.swift
//  C1_test
//
//  Created by Mason's Mac on 3/22/26.
//

import SwiftUI

struct Mentors : Identifiable {
    let id = UUID()
    var mentorName: String
    var mentorAvailable: String
    
}

struct MentorListRow: View {
    var mentorList: Mentors
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(mentorList.mentorName)
                .foregroundColor(.primary)
                .font(.headline)
            Text(mentorList.mentorAvailable)
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
    }
}


struct Expert: Identifiable {
    let id = UUID()
    var expertArea: String
    var mentor: [Mentors]
}

struct Academy {
    var experts: [Expert]
}

var academy = Academy(experts: [
    Expert(expertArea: "Tech", mentor: [
        Mentors(mentorName: "Issac", mentorAvailable: "가능"),
        Mentors(mentorName: "MK", mentorAvailable: "불가능"),
    ]),
    Expert(expertArea: "Design", mentor: [
        Mentors(mentorName: "Jiku", mentorAvailable: "가능")
    ])
])

struct MentorList: View {
    
    var body: some View {
        List {
            ForEach(academy.experts) { expert in
                Section{
                    ForEach(expert.mentor) { mentorList in
                        MentorListRow(mentorList: mentorList)
                    }
                } header: {
                    Text(expert.expertArea)
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
