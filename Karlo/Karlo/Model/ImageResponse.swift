//  Karlo - ImageResponse.swift
//  Created by zhilly on 2023/09/06

import Foundation

struct ImageConfiguration: Encodable {
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
    let noiseRemoveSteps: Int = 25
    let noiseRemoveScale: Double = 5.0
    let noiseRemoveStepsByDecoder: Int = 50
    let noiseRemoveScaleByDecoder: Double = 5.0
    let decoder: String = "decoder_ddim_v_prediction"
    let nsfwChecker: Bool = false
    
    enum CodingKeys: String, CodingKey {
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
        case noiseRemoveSteps = "prior_num_inference_steps"
        case noiseRemoveScale = "prior_guidance_scale"
        case noiseRemoveStepsByDecoder = "num_inference_steps"
        case noiseRemoveScaleByDecoder = "guidance_scale"
        case decoder = "scheduler"
        case nsfwChecker = "nsfw_checker"
    }
}

struct KarloResponseData: Decodable {
    let id: String
    let modelVersion: String
    let images: [ResultImage]
    
    enum CodingKeys: String, CodingKey {
        case id
        case modelVersion = "model_version"
        case images
    }
}

struct ResultImage: Decodable {
    let id: String
    let seed: Int
    let image: String
    let nsfwContentDetected: Bool?
    let nsfwScore: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, image, seed
        case nsfwContentDetected = "nsfw_content_detected"
        case nsfwScore = "nsfw_score"
    }
}
