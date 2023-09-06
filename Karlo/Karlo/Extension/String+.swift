//  Karlo - String+.swift
//  Created by zhilly on 2023/09/06

import Foundation

extension String {
    var hasHangul: Bool {
        return "\(self)".range(of: "\\p{Hangul}", options: .regularExpression) != nil
    }
}
