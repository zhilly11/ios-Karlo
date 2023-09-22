//  Karlo - KeywordTagFeature.swift
//  Created by zhilly on 2023/09/06

import UIKit
import ComposableArchitecture

struct KeywordTagFeature: Reducer {
    struct KeywordState: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        var rows: [[Tag]] = []
        var tags: [Tag] = []
        var tagText: String = .init()
        var prompt: String = .init()
    }
    
    enum KeywordAction: Equatable {
        case alert(PresentationAction<Alert>)
        case textChanged(String)
        case addTag
        case removeTag(id: String)
        case getTags
        
        enum Alert: Equatable { }
    }
    
    var body: some Reducer<KeywordState, KeywordAction> {
        Reduce { state, action in
            switch action {
                
            case let .textChanged(text):
                state.tagText = text
                return .none
                
            case .alert:
                return .none
                
            case .addTag:
                do {
                    try addTag(into: &state)
                    return .none
                } catch let error {
                    state.alert = AlertState {
                        TextState(error.localizedDescription)
                    } actions: {
                        ButtonState(role: .cancel) {
                            TextState(Constant.Text.check)
                        }
                    }
                    return .none
                }
            case .removeTag(let id):
                removeTag(into: &state, by: id)
                return .none
                
            case .getTags:
                getTags(into: &state)
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
}

extension KeywordTagFeature {
    private func addTag(into state: inout KeywordState) throws {
        var keywordCount: Int = 0
        
        state.tags.forEach { tag in
            keywordCount += tag.name.count
        }
        
        let isCorrect = try isCorrect(state.tagText, currentKeywordCount: keywordCount)
        
        if isCorrect {
            state.tags.append(Tag(name: state.tagText))
            state.tagText = .init()
            state.prompt = generatePrompt(state.tags)
            getTags(into: &state)
        }
    }
    
    private func removeTag(into state: inout KeywordState, by id: String) {
        state.tags = state.tags.filter{ $0.id != id }
        state.prompt = generatePrompt(state.tags)
        getTags(into: &state)
    }
    
    private func getTags(into state: inout KeywordState) {
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        var totalWidth: CGFloat = 0
        let screenWidth: CGFloat = UIScreen.screenWidth - 55
        let tagSpacing: CGFloat = 56
        
        if !state.tags.isEmpty {
            for index in 0..<state.tags.count {
                state.tags[index].size = state.tags[index].name.getSize()
            }
            
            state.tags.forEach { tag in
                totalWidth += (tag.size + tagSpacing)
                
                if totalWidth > screenWidth {
                    totalWidth = (tag.size + tagSpacing)
                    rows.append(currentRow)
                    currentRow.removeAll()
                    currentRow.append(tag)
                } else {
                    currentRow.append(tag)
                }
            }
            
            if !currentRow.isEmpty{
                rows.append(currentRow)
                currentRow.removeAll()
            }
            
            state.rows = rows
        } else {
            state.rows = []
        }
    }
    
    private func isCorrect(_ keyword: String, currentKeywordCount: Int) throws -> Bool {
        if keyword == .init() { throw KeywordError.emptyKeyword }
        if keyword.hasHangul { throw KeywordError.containHangul }
        if currentKeywordCount + keyword.count >= Constant.Karlo.promptMaxSize { throw KeywordError.overRange }
        
        return true
    }
    
    private func generatePrompt(_ tags: [Tag]) -> String {
        return tags.map { $0.name }.joined(separator: Constant.Symbol.comma)
    }
}
