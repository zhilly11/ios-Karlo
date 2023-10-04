//  Karlo - KeywordTag.swift
//  Created by zhilly on 2023/09/06

import Foundation

struct Tag: Identifiable, Hashable {
    var id: UUID = .init()
    var name: String
    var size: CGFloat = 0
}
