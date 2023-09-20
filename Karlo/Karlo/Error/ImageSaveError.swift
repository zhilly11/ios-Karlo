//  Karlo - ImageSaveError.swift
//  Created by zhilly on 2023/09/20

import Foundation

enum ImageSaveError: LocalizedError {
    case failure
    
    var errorDescription: String? {
        switch self {
        case .failure:
            return "이미지 저장 실패"
        }
    }
}
