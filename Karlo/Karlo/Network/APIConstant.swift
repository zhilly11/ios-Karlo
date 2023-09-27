//  Karlo - APIConstant.swift
//  Created by zhilly on 2023/09/12

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum HTTPHeader {
    case contentType
    case authorization(key: String)
    
    var field: String {
        switch self {
        case .contentType:
            return "Content-Type"
        case .authorization:
            return "Authorization"
        }
    }
    
    var value: String {
        switch self {
        case .contentType:
            return "application/json"
        case .authorization(let apikey):
            return "KakaoAK \(apikey)"
        }
    }
}

enum EndPoint: String {
    case generation = "t2i"
    case transformation = "variations"
}
