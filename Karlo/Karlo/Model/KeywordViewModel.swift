//  Karlo - KeywordViewModel.swift
//  Created by zhilly on 2023/09/06

import UIKit

class KeywordViewModel: ObservableObject {
    @Published var rows: [[Tag]] = []
    @Published var tags: [Tag] = []
    @Published var tagText: String = ""
    
    init() {
        getTags()
    }
    
    func addTag() throws {
        let isCorrect = try isCorrect(tagText)
        if isCorrect {
            tags.append(Tag(name: tagText))
            tagText = ""
            getTags()
        }
    }
    
    func removeTag(by id: String) {
        tags = tags.filter{ $0.id != id }
        getTags()
    }
    
    
    func getTags() {
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        var totalWidth: CGFloat = 0
        let screenWidth: CGFloat = UIScreen.screenWidth - 55
        let tagSpacing: CGFloat = 56
        
        if !tags.isEmpty {
            for index in 0..<tags.count {
                self.tags[index].size = tags[index].name.getSize()
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
        } else {
            self.rows = []
        }
    }
    
    private func isCorrect(_ keyword: String) throws -> Bool {
        if keyword == "" { throw KeywordError.emptyKeyword }
        if keyword.hasHangul { throw KeywordError.containHangul }
        
        var promptCount: Int = 0
        
        tags.forEach { tag in
            promptCount += tag.name.count + 1
        }
        
        promptCount += keyword.count
        
        if promptCount >= 256 { throw KeywordError.overRange }
        
        return true
    }
    
    func exportPrompt() -> String {
        return tags.map { $0.name }.joined(separator: ", ")
    }
}
