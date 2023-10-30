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
        guard let plistUrl = self.url(forResource: file.secret.name, withExtension: file.secret.type),
              let plistData = try? Data(contentsOf: plistUrl),
              let plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, format: nil),
              let resource = plistDictionary as? [String: AnyObject],
              let key = resource["API_KEY"] as? String else {
            return nil
        }
        
        return key
    }
}
