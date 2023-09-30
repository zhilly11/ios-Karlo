//  KarloTests - ImageGenerateFeatureTests.swift
//  Created by zhilly on 2023/09/27

import ComposableArchitecture
import XCTest

@testable import Karlo

@MainActor
final class ImageGenerateFeatureTests: XCTestCase {
    func testImageConfigureOptions() async {
        let store = TestStore(initialState: ImageGenerateFeature.State()) {
            ImageGenerateFeature()
        }
        
        let testData: ImageConfigurationRequest = .init(
            prompt: "",
            negativePrompt: "",
            width: 256,
            height: 256,
            upscale: true,
            scale: 4,
            imageQuality: 100,
            imageCount: 3
        )
        
        await store.send(.imageWidthChanged(testData.width)) {
            $0.imageWidth = testData.width
        }
        await store.send(.imageHeightChanged(testData.height)) {
            $0.imageHeight = testData.height
        }
        await store.send(.imageUpscaleToggle(isOn: testData.upscale)) {
            $0.imageUpscale = testData.upscale
        }
        await store.send(.imageScaleToggle(isOn: true)) {
            $0.imageScale = true
        }
        await store.send(.imageQualityChanged(Double(testData.imageQuality))) {
            $0.imageQuality = Double(testData.imageQuality)
        }
        await store.send(.imageCountChanged(testData.imageCount)) {
            $0.imageCount = testData.imageCount
        }
        await store.send(.setSheet(isPresented: true)) {
            $0.imageConfigurationRequest = testData
            $0.isAlbumViewPresented = true
        }
        await store.send(.setSheet(isPresented: false)) {
            $0.isAlbumViewPresented = false
        }
    }
}
