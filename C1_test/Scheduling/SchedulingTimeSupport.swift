import Foundation
import SwiftUI
import UIKit

enum SchedulingTimePolicy {
    static func minimumDate(from now: Date = Date()) -> Date {
        ceilToNextHalfHour(from: now)
    }

    static func normalize(_ date: Date, now: Date = Date()) -> Date {
        max(
            ceilToNextHalfHour(from: date),
            minimumDate(from: now)
        )
    }

    private static func ceilToNextHalfHour(from date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)

        guard
            let year = components.year,
            let month = components.month,
            let day = components.day,
            let hour = components.hour,
            let minute = components.minute
        else {
            return date
        }

        let roundedMinute: Int
        let adjustedHour: Int

        switch minute {
        case 0:
            roundedMinute = 0
            adjustedHour = hour
        case 1...30:
            roundedMinute = 30
            adjustedHour = hour
        default:
            roundedMinute = 0
            adjustedHour = hour + 1
        }

        return calendar.date(from: DateComponents(
            year: year,
            month: month,
            day: day,
            hour: adjustedHour,
            minute: roundedMinute
        )) ?? date
    }
}

struct HalfHourTimePicker: UIViewRepresentable {
    @Binding var selection: Date
    let minimumDate: Date

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .compact
        picker.minuteInterval = 30
        picker.minimumDate = minimumDate
        picker.locale = Locale(identifier: "ko_KR")
        picker.overrideUserInterfaceStyle = .light
        picker.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        return picker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.minimumDate = minimumDate
        let adjustedSelection = max(selection, minimumDate)

        if adjustedSelection != selection {
            DispatchQueue.main.async {
                selection = adjustedSelection
            }
        }

        if uiView.date != adjustedSelection {
            uiView.date = adjustedSelection
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selection: $selection)
    }

    final class Coordinator: NSObject {
        @Binding var selection: Date

        init(selection: Binding<Date>) {
            _selection = selection
        }

        @objc func valueChanged(_ sender: UIDatePicker) {
            selection = sender.date
        }
    }
}
