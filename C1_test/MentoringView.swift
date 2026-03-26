//
//  SubView.swift
//  C1_test
//
//  Created by Mason's Mac on 3/22/26.
//

import SwiftUI

struct Mentors: Identifiable {
  let mentorName: String
  let mentorAvailable: Bool
  let id = UUID()
  
}


struct SchedulingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var topExpanded: Bool = true
    @State private var mentoringDate = Date()
    @State private var fullText: String = "This is some editable text..."
    @State private var availableMentor = [
        Mentors(mentorName: "아이작", mentorAvailable: true),
        Mentors(mentorName: "지쿠", mentorAvailable: true),
        Mentors(mentorName: "MK", mentorAvailable: false)
     ]
    
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
            
            DisclosureGroup("Mentors", isExpanded: $topExpanded) {
                
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
    }
}
#Preview {
    SchedulingView()
}
