//  Karlo - NetworkError.swift
//  Created by zhilly on 2023/09/07

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidServerResponse
    case unsupportedData
    case fetchFailAPIKey
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "url에 문제가 생겼습니다."
        case .invalidServerResponse:
            return "서버로부터 응답이 없습니다."
        case .unsupportedData:
            return "데이터가 잘못되었습니다."
        case .fetchFailAPIKey:
            return "API Key를 가져오지 못했습니다."
        }
    }
}
