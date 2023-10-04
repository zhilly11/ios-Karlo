//  KarloTests - KeywordTagFeatureTests.swift
//  Created by zhilly on 2023/09/30

import ComposableArchitecture
import XCTest

@testable import Karlo

@MainActor
final class KeywordTagFeatureTests: XCTestCase {
    func testAddWrongKeywordTag() async {
        let testWrongPrompt: String = "안녕하세요"
        
        let store = TestStore(initialState: KeywordTagFeature.State()) {
            KeywordTagFeature()
        }
        
        await store.send(.textChanged(testWrongPrompt)) {
            $0.tagStore.tagText = testWrongPrompt
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
    }
    
    func testAddRightKeywordAndRemove() async {
        let testPrompt: String = "Pepe the frog playing Game"
        let testTagID: UUID = .init()
        
        let store = TestStore(initialState: KeywordTagFeature.State()) {
            KeywordTagFeature()
        }
        
        await store.send(.textChanged(testPrompt)) {
            $0.tagStore.tagText = testPrompt
        }
        
        await store.send(.addTag(id: testTagID)) {
            let tag: Tag = Tag(id: testTagID,
                               name: testPrompt,
                               size: testPrompt.getSize())
            
            $0.tagStore.tags.append(tag)
            $0.tagStore.tagText = .init()
            $0.tagStore.prompt = testPrompt
            $0.tagStore.getTags()
        }
        
        await store.send(.removeTag(id: testTagID)) {
            $0.tagStore.tags = $0.tagStore.tags.filter{ $0.id != testTagID }
            $0.tagStore.prompt = $0.tagStore.generatePrompt($0.tagStore.tags)
            $0.tagStore.getTags()
        }
    }
}
