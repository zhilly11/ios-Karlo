//  Karlo - Bundle+.swift
//  Created by zhilly on 2023/09/12

import Foundation

extension Bundle {
    private enum file {
        case secret
        
        var name: String {
            switch self {
            case .secret:
                return "Secret"
            }
        }
        
        var type: String {
            switch self {
            case .secret:
                return "plist"
            }
        }
    }
    
    var apiKey: String? {
        guard let filePath: String = self.path(forResource: file.secret.name, ofType: file.secret.type),
              let resource: NSDictionary = .init(contentsOfFile: filePath),
              let key: String = resource["API_KEY"] as? String else {
            return nil
        }
        
        return key
    }
}
