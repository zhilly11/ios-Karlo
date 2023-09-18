//  Karlo - AlbumFeature.swift
//  Created by zhilly on 2023/09/13

import Foundation
import ComposableArchitecture

struct AlbumFeature: Reducer {
    private let apiService: KarloAPI = .init(session: URLSession.shared)
    
    struct AlbumState: Equatable {
        var imageConfiguration: ImageConfiguration
        
        var imageData: [Data] = []
        var proceeding = false
    }
    
    enum AlbumAction: Equatable {
        case onAppear
        case imageResponse(TaskResult<[Data]>)
        case setProceeding(_ flag: Bool)
    }
    
    func reduce(into state: inout AlbumState, action: AlbumAction) -> Effect<AlbumAction> {
        switch action {
        case .onAppear:
            return .run { [info = state.imageConfiguration ] send in
                await send(.setProceeding(true))
                await send(.imageResponse(
                    TaskResult { try await
                        apiService.generateImage(info: info)
                    })
                )
                await send(.setProceeding(false))
            }
        case let .imageResponse(.success(response)):
            state.imageData = response
            return .none
        case .imageResponse(.failure):
            return .none
        case let .setProceeding(flag):
            state.proceeding = flag
            return .none
        }
    }
}
