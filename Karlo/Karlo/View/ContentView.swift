//  Karlo - ContentView.swift
//  Created by zhilly on 2023/08/28

import SwiftUI

struct ContentView: View {
    @StateObject var positiveKeywordViewModel: KeywordViewModel = .init()
    @StateObject var negativeKeywordViewModel: KeywordViewModel = .init()
    @State private var isErrorKeyword: Bool = false
    @State private var keywordError: KeywordError? = nil
    
    var body: some View {
        VStack {
            HStack {
                Form {
                    Section("긍정 제시어 입력") {
                        KeywordInputView(isErrorKeyword: $isErrorKeyword, keywordError: $keywordError)
                            .environmentObject(positiveKeywordViewModel)
                    }
                    
                    Section("긍정 제시어") {
                        KeywordTagView()
                            .environmentObject(positiveKeywordViewModel)
                    }
                    
                    Section("부정 제시어 입력") {
                        KeywordInputView(isErrorKeyword: $isErrorKeyword, keywordError: $keywordError)
                            .environmentObject(negativeKeywordViewModel)
                    }
                    
                    Section("부정 제시어") {
                        KeywordTagView()
                            .environmentObject(negativeKeywordViewModel)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
