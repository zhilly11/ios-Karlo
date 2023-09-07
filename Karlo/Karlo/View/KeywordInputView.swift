//  Karlo - KeywordInputView.swift
//  Created by zhilly on 2023/09/07

import SwiftUI

struct KeywordInputView: View {
    @EnvironmentObject var viewModel: KeywordViewModel
    @Binding var isErrorKeyword: Bool
    @Binding var keywordError: KeywordError?
    
    var body: some View {
        HStack {
            TextField(
                "제시어",
                text: $viewModel.tagText
            )
            .submitLabel(.done)
            
            Button("추가") {
                determine(keyword: $viewModel.tagText.wrappedValue)
            }
            .alert(isPresented: $isErrorKeyword, error: keywordError) {
                Button("OK", role: .cancel) { }
            }
        }
    }
    
    private func determine(keyword: String) {
        isErrorKeyword = false
        
        do {
            try viewModel.addTag()
            keywordError = nil
        } catch let error as KeywordError {
            isErrorKeyword = true
            keywordError = error
        } catch {
            print("알 수 없는 에러가 발생했습니다: \(error)")
        }
    }
}
