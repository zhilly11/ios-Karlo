//  Karlo - ContentView.swift
//  Created by zhilly on 2023/08/28

import SwiftUI

struct ContentView: View {
    @State private var keyword: String = ""
    @State private var inputArray: [String] = []
    @State private var isErrorKeyword: Bool = false
    @State private var keywordError: KeywordError? = nil
    
    private var showingKeyword: Bool {
        return inputArray.count > 0 ? true : false
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
                        TextField(
                            "제시어",
                            text: $keyword
                        )
                        .submitLabel(.done)
                        
                        Button("추가") {
                            determine(keyword: keyword)
                        }
                        .alert(isPresented: $isErrorKeyword, error: keywordError) {
                            Button("OK", role: .cancel) { }
                        }
                    }
                }
                
                if showingKeyword {
                    Section("제시어") {
                        List {
                            ForEach(inputArray, id: \.self) { string in
                                Text(string)
                            }
                            .onDelete { indexSet in
                                inputArray.remove(atOffsets: indexSet)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func isCorrect(_ keyword: String) throws -> Bool {
        if keyword == "" { throw KeywordError.emptyKeyword }
        if keyword.hasHangul { throw KeywordError.containHangul }
        if keyword.count >= 256 { throw KeywordError.overRange }
        
        return true
    }
    
    private func determine(keyword: String) {
        isErrorKeyword = false
        
        do {
            isErrorKeyword = try !isCorrect(keyword)
            keywordError = nil
            inputArray.append(keyword)
            self.keyword = ""
        } catch let error as KeywordError {
            isErrorKeyword = true
            keywordError = error
        } catch {
            print("알 수 없는 에러가 발생했습니다: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
