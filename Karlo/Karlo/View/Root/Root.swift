//  Karlo - Root.swift
//  Created by zhilly on 2023/09/13

import ComposableArchitecture

struct Root: Reducer {
    struct State: Equatable {
        var imageGenerate = ImageGenerateFeature.State()
    }
    
    enum Action {
        case onAppear
        case imageGenerate(ImageGenerateFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state = .init()
                return .none
            default:
                return .none
            }
        }
        
        Scope(state: \.imageGenerate, action: /Action.imageGenerate) {
            ImageGenerateFeature()
        }
    }
}
