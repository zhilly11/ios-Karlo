//  Karlo - KarloResponse.swift
//  Created by zhilly on 2023/09/27

import Foundation

protocol KarloResponsible: Decodable { }

struct KarloResponse: KarloResponsible {  
    let id: String
    let modelVersion: String
    let images: [ResultImage]
    
    enum CodingKeys: String, CodingKey {
        case id
        case modelVersion = "model_version"
        case images
    }
}

extension KarloResponse: Equatable {
    static func == (lhs: KarloResponse, rhs: KarloResponse) -> Bool {
        return lhs.id == rhs.id
    }
}

extension KarloResponse {
    static let mock = SampleData.fetchMockData()!
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
