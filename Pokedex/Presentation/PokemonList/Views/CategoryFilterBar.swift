import SwiftUI

struct CategoryFilterBar: View {
    let types: [String]
    let selectedType: String?
    let onSelect: (String?) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryChipView(
                    label: "Todos",
                    color: .gray,
                    isSelected: selectedType == nil,
                    action: { onSelect(nil) }
                )

                ForEach(types, id: \.self) { type in
                    CategoryChipView(
                        label: type.capitalized,
                        color: PokemonTypeColor.color(for: type),
                        isSelected: selectedType == type,
                        action: { onSelect(type) }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct CategoryChipView: View {
    let label: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(width: 80)
                .padding(.vertical, 6)
                .background(isSelected ? color : color.opacity(0.15))
                .foregroundStyle(isSelected ? .white : color)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(color, lineWidth: isSelected ? 0 : 1)
                )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        .padding(.vertical,5)
        
    }
}

#Preview {
    CategoryFilterBar(
        types: ["grass", "fire", "water", "electric"],
        selectedType: "fire",
        onSelect: { _ in }
    )
}
