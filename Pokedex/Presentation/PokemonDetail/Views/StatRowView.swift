import SwiftUI

struct StatRowView: View {
    let stat: PokemonStat
    let accentColor: Color

    /// Base stats in PokeAPI rarely exceed 150 (255 is the theoretical max
    /// for outliers) — 150 keeps the bar readable for the typical range.
    private var normalizedValue: Double {
        min(Double(stat.value) / 150.0, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(stat.name.capitalized)
                    .font(.caption)
                Spacer()
                Text("\(stat.value)")
                    .font(.caption.bold())
            }
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(stat.value <= 45 ? .pink : accentColor)
                            .frame(width: geometry.size.width * normalizedValue)
                    }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    StatRowView(stat: PokemonStat(name: "attack", value: 44), accentColor: .orange)
        .padding()
}
