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
    func generateImage(info imageConfiguration: ImageConfiguration) async throws -> [Data] {
        let encoder: JSONEncoder = .init()
        let jsonData: Data = try encoder.encode(imageConfiguration)
        var request: URLRequest = try configureRequest()
        
        request.httpBody = jsonData
        
        let (data, response): (Data, URLResponse) = try await session.data(for: request)
        let successRange: (Range<Int>) = (200..<300)
        
        guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse,
              successRange.contains(httpResponse.statusCode) else {
            throw NetworkError.invalidServerResponse
        }
        
        let decoder: JSONDecoder = .init()
        let responseData = try decoder.decode(KarloResponseData.self, from: data)
        var result: [Data] = .init()
        
        responseData.images.forEach {
            if let data = Data(base64Encoded: $0.image) {
                result.append(data)
            }
        }
                
        return result
    }
}

extension KarloAPI {
    private func configureRequest() throws -> URLRequest {
        guard let apiKey: String = Bundle.main.apiKey else {
            throw NetworkError.fetchFailAPIKey
        }
        
        guard let baseURL: URL = URL.makeForEndpoint() else {
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
