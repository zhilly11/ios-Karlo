//  Karlo - URLRequest+.swift
//  Created by zhilly on 2023/09/12

import Foundation

extension URLRequest {
    mutating func setupHeader(_ header: HTTPHeader) {
        self.setValue(header.value, forHTTPHeaderField: header.field)
    }
}
