import SwiftUI

struct EmptyMentoringView: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 16) {
                
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.12))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                }
                
                VStack(spacing: 6) {
                    Text("예약된 멘토링이 없습니다")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("새로운 멘토링을 신청하려면 눌러주세요")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 220)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(.white))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        Color.secondary.opacity(0.5),
                        style: StrokeStyle(lineWidth: 1.5, dash: [7])
                    )
            )
            .padding(.horizontal, 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
        EmptyMentoringView {
            print("Tapped")
    }
}
