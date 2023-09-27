//  Karlo - URL+.swift
//  Created by zhilly on 2023/09/12

import Foundation

extension URL {
    static let baseURL: String = "https://api.kakaobrain.com/v2/inference/karlo/"
    
    static func makeForEndpoint(endpoint: String = .init()) -> URL? {
        return URL(string: baseURL + endpoint)
    }
}
