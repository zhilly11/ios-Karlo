//  Karlo - ImageGenerateFeature.swift
//  Created by zhilly on 2023/09/13

import ComposableArchitecture

struct ImageGenerateFeature: Reducer {
    struct State: Equatable {
        var prompt = KeywordTagFeature.State()
        var negativePrompt = KeywordTagFeature.State()
        
        var imageWidth: Int = 512
        var imageHeight: Int = 512
        var imageScale: Bool = false
        var imageQuality: Double = 70
        var imageCount: Int = 1
        
        var isAlbumViewPresented: Bool = false
        var albumFeature: AlbumFeature.State?
        var imageConfiguration: ImageConfiguration?
    }
    
    enum Action: Equatable {
        case prompt(KeywordTagFeature.Action)
        case negativePrompt(KeywordTagFeature.Action)
        case imageWidthChanged(Int)
        case imageHeightChanged(Int)
        case imageScaleToggle(isOn: Bool)
        case imageQualityChanged(Double)
        case imageCountChanged(Int)
        
        case setSheet(isPresented: Bool)
        
        case export
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .imageWidthChanged(value):
                state.imageWidth = value
                return .none
                
            case let .imageHeightChanged(value):
                state.imageHeight = value
                return .none
                
            case let .imageScaleToggle(isOn):
                state.imageScale = isOn
                return .none
                
            case let .imageQualityChanged(value):
                state.imageQuality = value
                return .none
                
            case let .imageCountChanged(value):
                state.imageCount = value
                return .none
                
            case .setSheet(isPresented: true):
                state.imageConfiguration = exportImageConfiguration(from: state)
                state.isAlbumViewPresented = true
                return .none
                
            case .setSheet(isPresented: false):
                state.isAlbumViewPresented = false
                return .none
                
            default :
                return .none
            }
        }
        Scope(state: \.prompt, action: /Action.prompt) {
            KeywordTagFeature()
        }
        Scope(state: \.negativePrompt, action: /Action.negativePrompt) {
            KeywordTagFeature()
        }
    }
}

extension ImageGenerateFeature {
    func exportImageConfiguration(from state: State) -> ImageConfiguration {
        return ImageConfiguration(
            prompt: state.prompt.prompt,
            negativePrompt: state.negativePrompt.prompt,
            width: state.imageWidth,
            height: state.imageHeight,
            upscale: state.imageScale,
            scale: 2,
            imageQuality: Int(state.imageQuality),
            imageCount: state.imageCount
        )
    }
}
