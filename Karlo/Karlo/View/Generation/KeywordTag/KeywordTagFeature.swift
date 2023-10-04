//  Karlo - KeywordTagFeature.swift
//  Created by zhilly on 2023/09/06

import UIKit
import ComposableArchitecture

struct KeywordTagFeature: Reducer {
    struct KeywordState: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        var tagStore: TagStore = .init()
    }
    
    enum KeywordAction: Equatable {
        case alert(PresentationAction<Alert>)
        case textChanged(String)
        case addTag(id: UUID = .init())
        case removeTag(id: UUID)
        case getTags
        
        enum Alert: Equatable { }
    }
    
    var body: some Reducer<KeywordState, KeywordAction> {
        Reduce { state, action in
            switch action {
                
            case let .textChanged(text):
                state.tagStore.tagText = text
                return .none
                
            case .alert:
                return .none
                
            case .addTag(let id):
                do {
                    try state.tagStore.addTag(id: id)
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
                state.tagStore.removeTag(by: id)
                return .none
                
            case .getTags:
                state.tagStore.getTags()
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
}
