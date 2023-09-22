//  Karlo - KeywordInputView.swift
//  Created by zhilly on 2023/09/07

import SwiftUI
import ComposableArchitecture

struct KeywordInputView: View {
    private let store: StoreOf<KeywordTagFeature>
    @ObservedObject private var viewStore: ViewStoreOf<KeywordTagFeature>
    
    init(store: StoreOf<KeywordTagFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        HStack {
            TextField(
                Constant.Text.prompt,
                text: viewStore.binding(
                    get: \.tagText,
                    send: KeywordTagFeature.Action.textChanged
                )
            )
            
            Button(Constant.ButtonTitle.add) {
                viewStore.send(.addTag)
            }
            .alert(
                store: self.store.scope(state: \.$alert, action: { .alert($0) })
            )
        }
    }
}
