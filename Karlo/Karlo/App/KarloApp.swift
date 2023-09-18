//  Karlo - KarloApp.swift
//  Created by zhilly on 2023/08/28

import SwiftUI
import ComposableArchitecture

@main
struct KarloApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(initialState: Root.State(), reducer: {
                    Root()
                })
            )
        }
    }
}
