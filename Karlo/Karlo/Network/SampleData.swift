//  Karlo - SampleData.swift
//  Created by zhilly on 2023/09/07

import Foundation

struct SampleData {
    static let sampleImageInfo = ImageConfigurationRequest(
        prompt: "Pepe the frog playing valorant, headset, RGB Gaiming, 4k",
        negativePrompt: "object out of frame, out of frame, body out of frame",
        width: 512,
        height: 512,
        upscale: false,
        scale: 2,
        imageQuality: 70,
        imageCount: 1
    )
    
    static let sampleImageData: [String] = [loadImageData(), loadImageData()]
    
    static func fetchSampleData() throws -> [String] {
        return sampleImageData
    }
    
    static func loadImageData() -> String {
        if let path = Bundle.main.path(forResource: "SampleImageData.txt", ofType: nil) {
            do {
                let fileContents = try String(contentsOfFile: path, encoding: .utf8)
                return fileContents
            } catch {
                print("파일 읽기 중 에러 발생: \(error)")
                return .init()
            }
        } else {
            print("파일을 찾을 수 없습니다.")
            return .init()
        }
    }
}
