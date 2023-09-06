//  Karlo - KeywordError.swift
//  Created by zhilly on 2023/09/06

import Foundation

enum KeywordError: LocalizedError {
    case emptyKeyword
    case containHangul
    case overRange
    
    var errorDescription: String? {
        switch self {
        case .emptyKeyword:
            return "제시어가 비어있습니다."
        case .containHangul:
            return "제시어에 한글 포함이 불가능합니다."
        case .overRange:
            return "제시어는 256자 이하여야 합니다."
        }
    }
}
