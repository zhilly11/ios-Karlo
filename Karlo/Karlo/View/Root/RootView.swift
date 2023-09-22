//  Karlo - RootView.swift
//  Created by zhilly on 2023/09/13

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    private let store: StoreOf<Root>
    @ObservedObject private var viewStore: ViewStoreOf<Root>

    init(store: StoreOf<Root>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink {
                        ImageGenerateView(
                            store: self.store.scope(
                                state: \.imageGenerate,
                                action: Root.Action.imageGenerate
                            )
                        )
                    } label: {
                        HStack(spacing: Constant.Layout.Spacing.medium) {
                            Constant.SystemImage.generation
                                .resizable()
                                .frame(width: Constant.Layout.minimumIconSize,
                                       height: Constant.Layout.minimumIconSize)
                                .foregroundColor(Color.blue)
                                
                            VStack(alignment: .leading, spacing: Constant.Layout.Spacing.small) {
                                Text(Constant.Title.imageGenerate)
                                    .bold()
                                Text(Constant.Description.imageGeneration)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .navigationTitle(Constant.Title.appTitle)
            .onAppear{ self.store.send(.onAppear) }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: Store(initialState: Root.State()) {
                Root()
            }
        )
    }
}
