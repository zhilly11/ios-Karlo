//  Karlo - JSONDecoder+.swift
//  Created by zhilly on 2023/10/10

import Foundation

extension JSONDecoder {
    static func decodeResponse(_ data: Data) throws -> KarloResponse {
        let decoder: JSONDecoder = .init()
        let responseData: KarloResponse = try decoder.decode(KarloResponse.self, from: data)
        
        return responseData
    }
}
