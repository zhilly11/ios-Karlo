//  Karlo - AlbumFeature.swift
//  Created by zhilly on 2023/09/13

import SwiftUI
import ComposableArchitecture

struct AlbumFeature: Reducer {
    struct AlbumState: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        
        var imageConfigurationRequest: ImageConfigurationRequest
        var imageData: [Data] = []
        var proceeding = false
    }
    
    enum AlbumAction: Equatable {
        case alert(PresentationAction<Alert>)
        case onAppear
        case imageResponse(TaskResult<KarloResponse>)
        case setProceeding(_ flag: Bool)
        case saveImage(data: Data)
        
        enum Alert: Equatable { }
    }
    
    @Dependency(\.karloClient) var karloClient
    
    var body: some Reducer<AlbumState, AlbumAction> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [info = state.imageConfigurationRequest] send in
                    await send(.setProceeding(true))
                    await send(.imageResponse(TaskResult { try await self.karloClient.fetch(info) }),
                               animation: .default)
                    await send(.setProceeding(false))
                }
                
            case let .imageResponse(.success(response)):
                response.images.forEach {
                    if let data = Data(base64Encoded: $0.image) {
                        state.imageData.append(data)
                    }
                }
                return .none
                
            case let .imageResponse(.failure(error)):
                state.alert = AlertState {
                    TextState(error.localizedDescription)
                } actions: {
                    ButtonState(role: .none) {
                        TextState(Constant.Text.check)
                    }
                }
                return .none
                
            case let .setProceeding(flag):
                state.proceeding = flag
                return .none
                
            case .alert:
                return .none
                
            case let .saveImage(data):
                do {
                    try saveImageToPhotoAlbum(imageData: data)
                    state.alert = AlertState {
                        TextState(Constant.AlertMessage.imageSaveSuccess)
                    } actions: {
                        ButtonState(role: .none) {
                            TextState(Constant.Text.check)
                        }
                    }
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
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
}

extension AlbumFeature {
    private func saveImageToPhotoAlbum(imageData: Data) throws {
        guard let image: UIImage = .init(data: imageData) else { throw ImageSaveError.failure }
        
        let imageManager: ImageManager = .init()
        var imageSaveError: Error? = nil
        
        imageManager.errorHandler = { imageSaveError = $0 }
        
        if imageSaveError != nil { throw ImageSaveError.failure }
        
        imageManager.writeToPhotoAlbum(image: image)
    }
}
