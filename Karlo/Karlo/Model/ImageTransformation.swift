//  Karlo - ImageTransformation.swift
//  Created by zhilly on 2023/09/26

import Foundation

struct ImageTransformationRequest: Encodable {
    let imageData: String
    let prompt: String
    let negativePrompt: String
    let width: Int
    let height: Int
    let upscale: Bool
    let scale: Int
    let imageFormat: String = "png"
    let imageQuality: Int
    let imageCount: Int
    let returnType: String = "base64_string"
    
    enum CodingKeys: String, CodingKey {
        case imageData = "image"
        case prompt
        case negativePrompt = "negative_prompt"
        case width
        case height
        case upscale
        case scale
        case imageFormat = "image_format"
        case imageQuality = "image_quality"
        case imageCount = "samples"
        case returnType = "return_type"
    }
}
