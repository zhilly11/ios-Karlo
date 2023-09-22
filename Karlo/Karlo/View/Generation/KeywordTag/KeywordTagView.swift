//  Karlo - KeywordTagView.swift
//  Created by zhilly on 2023/09/07

import SwiftUI
import ComposableArchitecture

struct KeywordTagView: View {
    private let store: StoreOf<KeywordTagFeature>
    @ObservedObject private var viewStore: ViewStoreOf<KeywordTagFeature>
    
    init(store: StoreOf<KeywordTagFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(viewStore.rows, id:\.self) { rows in
                    HStack(spacing: 6) {
                        ForEach(rows) { row in
                            Text(row.name)
                                .font(.system(size: 16))
                                .padding(.leading, 14)
                                .padding(.trailing, 30)
                                .padding(.vertical, 8)
                                .background(
                                    ZStack(alignment: .trailing) {
                                        Capsule()
                                            .fill(.ultraThinMaterial)
                                        Button {
                                            viewStore.send(.removeTag(id: row.id))
                                        } label: {
                                            Constant.SystemImage.xMark
                                                .frame(width: 15, height: 15)
                                                .padding(.trailing, 8)
                                                .foregroundColor(.red)
                                        }
                                    }
                                )
                        }
                    }
                    .frame(height: 28)
                    .padding(.bottom, 10)
                }
            }
            .padding(.top, 20)
        }
    }
}
