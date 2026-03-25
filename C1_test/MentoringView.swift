//
//  SubView.swift
//  C1_test
//
//  Created by Mason's Mac on 3/22/26.
//

import SwiftUI

struct SchedulingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var topExpanded: Bool = true
    @State private var date = Date()
    @State private var fullText: String = "This is some editable text..."
    @State var text: String = "신청"
    
    
    var body: some View {
        VStack(spacing: 16) {
            Text("새로운 멘토링")
                .font(.title)
            
            DatePicker(
                "Start Date",
                selection: $date,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            
            DisclosureGroup("Items", isExpanded: $topExpanded) {
                DisclosureGroup("Sub-items") {
                    Text("Sub-item 1")
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
    }
}
#Preview {
    SchedulingView()
}
