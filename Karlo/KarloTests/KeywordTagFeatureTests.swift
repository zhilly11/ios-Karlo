//  KarloTests - KeywordTagFeatureTests.swift
//  Created by zhilly on 2023/09/30

import ComposableArchitecture
import XCTest

@testable import Karlo

@MainActor
final class KeywordTagFeatureTests: XCTestCase {
    func testKeywordTag() async {
        let testWrongPrompt: String = "안녕하세요"
        let testPrompt: String = "Pepe the frog playing Game"
        let testTagID: UUID = .init()
        
        let store = TestStore(initialState: KeywordTagFeature.State()) {
            KeywordTagFeature()
        }
        
        await store.send(.textChanged(testWrongPrompt)) {
            $0.tagText = testWrongPrompt
        }
        
        await store.send(.addTag()) {
            $0.alert = AlertState {
                TextState(KeywordError.containHangul.localizedDescription)
            } actions: {
                ButtonState(role: .cancel) {
                    TextState(Constant.Text.check)
                }
            }
        }
        
        await store.send(.textChanged(testPrompt)) {
            $0.tagText = testPrompt
        }

        await store.send(.addTag(id: testTagID)) {
            let tag: Tag = Tag(id: testTagID,
                               name: testPrompt,
                               size: testPrompt.getSize())
            
            $0.tags.append(tag)
            $0.tagText = .init()
            $0.prompt = testPrompt
        }
    }
}
