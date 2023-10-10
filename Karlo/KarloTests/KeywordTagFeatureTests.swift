//  KarloTests - KeywordTagFeatureTests.swift
//  Created by zhilly on 2023/09/30

import ComposableArchitecture
import XCTest

@testable import Karlo

@MainActor
final class KeywordTagFeatureTests: XCTestCase {
    func testAddWrongKeywordTag() async {
        let testWrongPrompt: String = "안녕하세요"
        let emptyPrompt: String = ""
        let limitOverPrompt: String = """
            portrait of beautiful young woman, ((by Shilin Huang, photorealistic anime girl
            render, artgeem)), highly detailed face, digital art, impressionism,deep gaze, princess
            eyes, long golden blonde straight hair, straight hair, light makeup, gorgeous white and
            gold wedding dress, digital painting, sharp features, sharp focus, face centered,
            detailed eyes, British, illustration, kids-book, nature, playful, soft face, bokeh,
            soft lighting, bright light stained glass windows background, emotional, medieval
            fantasy, frontal gaze, romance fantasy webtoon, ((distant view)), best dynamic
            composition, ((Front face photo))
            """
        
        let store = TestStore(initialState: KeywordTagFeature.State()) {
            KeywordTagFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.textChanged(testWrongPrompt)) {
            $0.tagStore.tagText = testWrongPrompt
        }
        
        await store.send(.addTag) {
            $0.alert = AlertState {
                TextState(KeywordError.containHangul.localizedDescription)
            } actions: {
                ButtonState(role: .cancel) {
                    TextState(Constant.Text.check)
                }
            }
        }
        
        await store.send(.textChanged(emptyPrompt)) {
            $0.tagStore.tagText = emptyPrompt
        }
        
        await store.send(.addTag) {
            $0.alert = AlertState {
                TextState(KeywordError.emptyKeyword.localizedDescription)
            } actions: {
                ButtonState(role: .cancel) {
                    TextState(Constant.Text.check)
                }
            }
        }
        
        await store.send(.textChanged(limitOverPrompt)) {
            $0.tagStore.tagText = limitOverPrompt
        }
        
        await store.send(.addTag) {
            $0.alert = AlertState {
                TextState(KeywordError.overRange.localizedDescription)
            } actions: {
                ButtonState(role: .cancel) {
                    TextState(Constant.Text.check)
                }
            }
        }
    }
    
    func testAddRightKeywordAndRemove() async {
        let testPrompt: String = "Pepe the frog playing Game"
        let testTagID: UUID = UUID(0)
        
        let store = TestStore(initialState: KeywordTagFeature.State()) {
            KeywordTagFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.textChanged(testPrompt)) {
            $0.tagStore.tagText = testPrompt
        }
        
        await store.send(.addTag) {
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
