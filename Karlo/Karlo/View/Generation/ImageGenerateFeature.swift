//  Karlo - ImageGenerateFeature.swift
//  Created by zhilly on 2023/09/13

import ComposableArchitecture

struct ImageGenerateFeature: Reducer {
    struct State: Equatable {
        var prompt = KeywordTagFeature.State()
        var negativePrompt = KeywordTagFeature.State()
        
        var imageWidth: Int = Constant.Karlo.imageSize
        var imageHeight: Int = Constant.Karlo.imageSize
        var imageUpscale: Bool = Constant.Karlo.imageUpscale
        var imageScale: Bool = Constant.Karlo.imageScale
        var imageQuality: Double = Constant.Karlo.imageQuality
        var imageCount: Int = Constant.Karlo.imageCount
        
        var isAlbumViewPresented: Bool = false
        var albumFeature: AlbumFeature.State?
        var imageConfigurationRequest: ImageConfigurationRequest?
    }
    
    enum Action: Equatable {
        case prompt(KeywordTagFeature.Action)
        case negativePrompt(KeywordTagFeature.Action)
        case imageWidthChanged(Int)
        case imageHeightChanged(Int)
        case imageUpscaleToggle(isOn: Bool)
        case imageScaleToggle(isOn: Bool)
        case imageQualityChanged(Double)
        case imageCountChanged(Int)
        case setSheet(isPresented: Bool)
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
                
            case let .imageUpscaleToggle(isOn):
                state.imageUpscale = isOn
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
                state.imageConfigurationRequest = exportImageConfigurationRequest(from: state)
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
    func exportImageConfigurationRequest(from state: State) -> ImageConfigurationRequest {
        return ImageConfigurationRequest(
            prompt: state.prompt.tagStore.prompt,
            negativePrompt: state.negativePrompt.tagStore.prompt,
            width: state.imageWidth,
            height: state.imageHeight,
            upscale: state.imageUpscale,
            scale: state.imageScale == false ? Constant.Karlo.imageScaleTwice : Constant.Karlo.imageScaleQuadruple,
            imageQuality: Int(state.imageQuality),
            imageCount: state.imageCount
        )
    }
}
