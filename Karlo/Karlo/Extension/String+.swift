//  Karlo - String+.swift
//  Created by zhilly on 2023/09/06

import UIKit

extension String {
    var hasHangul: Bool {
        return "\(self)".range(of: "\\p{Hangul}", options: .regularExpression) != nil
    }
    
    func getSize() -> CGFloat {
        let font: UIFont = UIFont.systemFont(ofSize: 16)
        let attributes: [NSAttributedString.Key: UIFont] = [NSAttributedString.Key.font: font]
        let size: CGSize = (self as NSString).size(withAttributes: attributes)
        
        return size.width
    }
    
    func convertColonFormat(with value: Int? = nil) -> String {
        guard let value = value else { return self + Constant.Symbol.colon }
        
        return self + Constant.Symbol.colon + "\(value)"
    }
}
