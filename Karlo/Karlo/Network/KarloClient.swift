//  Karlo - KarloClient.swift
//  Created by zhilly on 2023/10/09

import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay

struct KarloClient {
    var fetch: @Sendable (Encodable) async throws -> KarloResponse
}

extension DependencyValues {
    var karloClient: KarloClient {
        get { self[KarloClient.self] }
        set { self[KarloClient.self] = newValue }
    }
}

extension KarloClient: DependencyKey {
    static let liveValue = Self(
        fetch: { imageInfo in
            let karloAPI: KarloAPI = .init(session: URLSession.shared)
            return try await karloAPI.request(data: imageInfo)
        }
    )
    
    static let previewValue = Self(
        fetch: { _ in .mock }
    )

    static let testValue = Self(
        fetch: unimplemented("\(Self.self).fetch")
    )
}
