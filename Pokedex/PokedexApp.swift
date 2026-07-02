//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Adrian Castañeda on 01/07/26.
//

import SwiftUI

@main
struct PokedexApp: App {
    private let dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            RootTabView(dependencies: dependencies)
        }
    }
}
