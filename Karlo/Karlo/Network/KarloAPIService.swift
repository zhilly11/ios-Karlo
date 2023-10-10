//  Karlo - KarloAPIService.swift
//  Created by zhilly on 2023/09/06

import Foundation

struct KarloAPI {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    /// KarolAPI에게 Image 생성을 요청하는 method 입니다.
    /// 매개변수에 이미지 생성 조건을 전달해 요청합니다.
    /// Image의 Data를 배열에 담아 return 합니다.
    func request<T: Encodable>(data: T) async throws -> KarloResponse {
        let encoder: JSONEncoder = .init()
        let jsonData: Data = try encoder.encode(data)
        var endPoint: EndPoint
        
        if data is ImageConfigurationRequest {
            endPoint = .generation
        } else if data is ImageTransformationRequest {
            endPoint = .transformation
        } else {
            throw NetworkError.unsupportedData
        }
        
        var request: URLRequest = try configureRequest(endPoint: endPoint)
        
        request.httpBody = jsonData
        
        let (data, response): (Data, URLResponse) = try await session.data(for: request)
        let successRange: (Range<Int>) = (200..<300)
        
        guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse,
              successRange.contains(httpResponse.statusCode) else {
            throw NetworkError.invalidServerResponse
        }
        
        return try JSONDecoder.decodeResponse(data)
    }
}

extension KarloAPI {
    private func configureRequest(endPoint: EndPoint) throws -> URLRequest {
        guard let apiKey: String = Bundle.main.apiKey else {
            throw NetworkError.fetchFailAPIKey
        }
        
        guard let baseURL: URL = URL.makeForEndpoint(endpoint: endPoint.rawValue) else {
            throw NetworkError.invalidURL
        }
        
        var request: URLRequest = .init(url: baseURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        let authorizationHeader: HTTPHeader = .authorization(key: apiKey)
        let contentTypeHeader: HTTPHeader = .contentType
        
        request.setupHeader(authorizationHeader)
        request.setupHeader(contentTypeHeader)
        
        return request
    }
}
