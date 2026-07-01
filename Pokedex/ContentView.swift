//
//  ContentView.swift
//  Pokedex
//
//  Created by Adrian Castañeda on 01/07/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        // TEMPORARY smoke test — remove once the Domain/Presentation layers exist.
        .task {
            await testAPIClient()
        }
    }

    private func testAPIClient() async {
        let client = APIClient()
        do {
            let list: PokemonListResponseDTO = try await client.request(
                PokemonEndpoint.list(limit: 20, offset: 0)
            )
            print("✅ LIST OK — count: \(list.count), results: \(list.results.count)")
            print("   first: \(list.results.first?.name ?? "-") id=\(list.results.first?.id ?? -1)")

            guard let firstId = list.results.first?.id else { return }
            let detail: PokemonDetailDTO = try await client.request(
                PokemonEndpoint.detail(id: firstId)
            )
            print("✅ DETAIL OK — \(detail.name) height=\(detail.height) weight=\(detail.weight)")
            print("   types: \(detail.types.map { $0.type.name })")
            print("   artwork: \(detail.sprites.other?.officialArtwork?.frontDefault ?? "nil")")
        } catch {
            print("❌ NETWORK TEST FAILED: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
