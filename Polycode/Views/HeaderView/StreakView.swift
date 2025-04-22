import SwiftUI

struct StreakView: View {
    let loggedDates: [Date]

    private let calendar = Calendar.current
    private let daysToShow = 30

    private var today: Date { calendar.startOfDay(for: Date()) }

    private var past30Days: [Date] {
        (0..<daysToShow).reversed().map {
            calendar.date(byAdding: .day, value: -$0, to: today)!
        }
    }

    private var loggedDaysSet: Set<Date> {
        Set(loggedDates.map { calendar.startOfDay(for: $0) })
    }

    private var currentStreak: Int {
        var streak = 0
        for offset in 0..<daysToShow {
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { break }
            if loggedDaysSet.contains(calendar.startOfDay(for: date)) {
                streak += 1
            } else if offset > 0 {
                break
            }
        }
        return streak
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("🔥 Current Streak: \(currentStreak) Days")
                .font(.title3.bold())

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(past30Days, id: \.self) { date in
                    let isLogged = loggedDaysSet.contains(date)
                    Text(shortDate(date))
                        .font(.caption2)
                        .padding(8)
                        .background(isLogged ? Color("KiwiFill") : Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }
        .padding()
    }

    private func shortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}
