//
//  SubView.swift
//  C1_test
//
//  Created by Mason's Mac on 3/22/26.
//

import SwiftUI

struct SchedulingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedMentorName: Mentor? = nil
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
            
            // Text("Mentoring is \(mentoringDate, formatter: dateFormatter)")
            
            HStack{
                Button {
                    isMentorListPresented = true
                } label: {
                    Text("Mentors")
                }
                
                
                if let selectedMentorName {
                    Text(selectedMentorName.mentorName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
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
            MentorsList(academy: sampleAcademy,
                        selectedMentorName: $selectedMentorName)
                
        }
    }
}


#Preview {
    SchedulingView()
}

#Preview {
    MentorsList(academy: sampleAcademy,selectedMentorName: .constant(nil)
    )
}
