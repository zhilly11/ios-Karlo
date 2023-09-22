//  Karlo - AppConstant.swift
//  Created by zhilly on 2023/09/14

import SwiftUI

/// Karlo App에서 사용되는 상수들
enum Constant {
    // MARK: - Navigation, Section Title
    struct Title {
        static let appTitle: String = "Karlo"
        static let imageGenerate: String = "이미지 생성하기"
        static let generatedImage: String = "생성된 이미지"
        
        struct Section {
            static let promptInput: String = "제시어 입력"
            static let prompt: String = "제시어"
            static let negativePromptInput: String = "부정 제시어 입력"
            static let negativePrompt: String = "부정 제시어"
            static let imageDetail: String = "이미지 상세 설정"
        }
    }
    
    // MARK: - Text
    struct Text {
        static let check: String = "확인"
        static let share: String = "공유"
        static let save: String = "저장"
        static let close: String = "닫기"
        
        static let prompt: String = "제시어"
        static let negativePrompt: String = "부정 제시어"
        static let width: String = "너비"
        static let height: String = "높이"
        static let upscale: String = "확대"
        static let scale: String = "고화질 확대"
        static let quality: String = "품질"
        static let imageCount: String = "이미지 개수"
        static let imageSize: String = "이미지 크기"
        
        static let generatingImage: String = "이미지 생성중..."
        static let imageSaveDescription: String = "이미지를 길게 누르면 저장 가능합니다."
    }
    
    struct Symbol {
        static let comma: String = ", "
        static let colon: String = " : "
    }
    
    struct ButtonTitle {
        static let add: String = "추가"
        static let imageGenerate: String = "이미지 생성"
    }
    
    struct AlertMessage {
        static let imageSaveSuccess: String = "사진 저장에 성공했습니다."
    }
    
    
    // MARK: - Default Value in Karlo API
    struct Karlo {
        static let imageSizes: [Int] = [384, 512, 640]
        static let imageSize: Int = 512
        static let imageQuality: Double = 70
        static let imageQualityMinimum: Double = 1
        static let imageQualityMaximum: Double = 100
        static let imageUpscale: Bool = false
        static let imageScale: Bool = false
        static let imageCount: Int = 1
        
        static func convertImageSizeString(width: Int, height: Int) -> String {
            return "\(width) * \(height)px"
        }
    }
    
    
    // MARK: - Design
    struct Layout {
        static let albumImageSize: CGFloat = 300
        static let largeTextSize: CGFloat = 110
        
        struct Spacing {
            static let small: CGFloat = 10
            static let medium: CGFloat = 20
            static let large: CGFloat = 30
        }
    }
    
    struct SystemImage {
        static let xMark: Image = .init(systemName: "xmark")
        static let share: Image = .init(systemName: "square.and.arrow.up")
        static let save: Image = .init(systemName: "square.and.arrow.down")
        static let info: Image = .init(systemName: "info.circle")
    }
}
