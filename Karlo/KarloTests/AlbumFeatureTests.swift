//  KarloTests - AlbumFeatureTests.swift
//  Created by zhilly on 2023/10/04

import ComposableArchitecture
import XCTest

@testable import Karlo

@MainActor
final class AlbumFeatureTests: XCTestCase {
    func testSuccessImageResponse() async {
        let testStore = TestStore(
            initialState: AlbumFeature.State(imageConfigurationRequest: SampleData.sampleImageInfo)
        ) {
            AlbumFeature()
        } withDependencies: {
            $0.karloClient.fetch = { _ in .mock }
        }
        
        await testStore.send(.setProceeding(true)) {
            $0.proceeding = true
        }
        
        await testStore.send(.imageResponse(.success(.mock))) {
            var mockData: [Data] = []
            
            KarloResponse.mock.images.forEach {
                if let data = Data(base64Encoded: $0.image) {
                    mockData.append(data)
                }
            }
            
            $0.imageData = mockData
        }
    }
    
    func testFailureImageResponse() async {
        let error = NetworkError.invalidServerResponse
        
        let testStore = TestStore(
            initialState: AlbumFeature.State(imageConfigurationRequest: SampleData.sampleImageInfo)
        ) {
            AlbumFeature()
        } withDependencies: {
            $0.karloClient.fetch = { _ in throw error }
        }
        
        await testStore.send(.imageResponse(.failure(error))) {
            $0.alert = AlertState {
                TextState(error.localizedDescription)
            } actions: {
                ButtonState(role: .none) {
                    TextState(Constant.Text.check)
                }
            }
        }
    }
    
    func testSuccessSaveImage() async {
        let testStore = TestStore(
            initialState: AlbumFeature.State(imageConfigurationRequest: SampleData.sampleImageInfo)
        ) {
            AlbumFeature()
        } withDependencies: {
            $0.karloClient.fetch = { _ in .mock }
        }
        
        guard let firstResultImage = KarloResponse.mock.images.first,
              let imageData = Data(base64Encoded: firstResultImage.image) else {
            return
        }
        
        await testStore.send(.saveImage(data: imageData)) {
            $0.alert = AlertState {
                TextState(Constant.AlertMessage.imageSaveSuccess)
            } actions: {
                ButtonState(role: .none) {
                    TextState(Constant.Text.check)
                }
            }
        }
    }
    
    func testFailureSaveImage() async {
        let testStore = TestStore(
            initialState: AlbumFeature.State(imageConfigurationRequest: SampleData.sampleImageInfo)
        ) {
            AlbumFeature()
        } withDependencies: {
            $0.karloClient.fetch = { _ in .mock }
        }
        
        let emptyImageData: Data = .init()
        
        await testStore.send(.saveImage(data: emptyImageData)) {
            $0.alert = AlertState {
                TextState(ImageSaveError.failure.localizedDescription)
            } actions: {
                ButtonState(role: .cancel) {
                    TextState(Constant.Text.check)
                }
            }
        }
    }
}
