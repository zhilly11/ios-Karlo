//  Karlo - TagStore.swift
//  Created by zhilly on 2023/10/04

import Foundation
import UIKit

struct TagStore: Equatable {
    var rows: [[Tag]] = []
    var tags: [Tag] = []
    var tagText: String = .init()
    var prompt: String = .init()
    
    mutating func addTag(id: UUID = .init()) throws {
        var keywordCount: Int = 0
        
        tags.forEach { tag in
            keywordCount += tag.name.count
        }
        
        let isCorrect = try tagText.isCorrect(currentKeywordCount: keywordCount)
        
        if isCorrect {
            tags.append(Tag(id: id, name: tagText))
            tagText = .init()
            prompt = generatePrompt(tags)
            getTags()
        }
    }
    
    mutating func removeTag(by id: UUID) {
        tags = tags.filter{ $0.id != id }
        prompt = generatePrompt(tags)
        getTags()
    }
    
    mutating func getTags() {
        if tags.isEmpty { self.rows = [] }
        
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        var totalWidth: CGFloat = 0
        let screenWidth: CGFloat = UIScreen.screenWidth - 55
        let tagSpacing: CGFloat = 56
        
        for index in 0..<tags.count {
            tags[index].size = tags[index].name.getSize()
        }
        
        tags.forEach { tag in
            totalWidth += (tag.size + tagSpacing)
            
            if totalWidth > screenWidth {
                totalWidth = (tag.size + tagSpacing)
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
            } else {
                currentRow.append(tag)
            }
        }
        
        if !currentRow.isEmpty{
            rows.append(currentRow)
            currentRow.removeAll()
        }
        
        self.rows = rows
    }
    
    func generatePrompt(_ tags: [Tag]) -> String {
        return tags.map { $0.name }.joined(separator: Constant.Symbol.comma)
    }
}
