//  Karlo - ContentView.swift
//  Created by zhilly on 2023/08/28

import SwiftUI

struct ContentView: View {
    @StateObject var positiveKeywordViewModel: KeywordViewModel = .init()
    @State private var isErrorKeyword: Bool = false
    @State private var keywordError: KeywordError? = nil
    
    var body: some View {
        VStack {
            Form {
                Section("긍정 제시어 입력") {
                    HStack {
                        TextField(
                            "제시어",
                            text: $positiveKeywordViewModel.tagText
                        )
                        .submitLabel(.done)
                        
                        Button("추가") {
                            determine(keyword: $positiveKeywordViewModel.tagText.wrappedValue)
                        }
                        .alert(isPresented: $isErrorKeyword, error: keywordError) {
                            Button("OK", role: .cancel) { }
                        }
                    }
                }
                
                Section("긍정 제시어") {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(positiveKeywordViewModel.rows, id:\.self) { rows in
                                HStack(spacing: 6) {
                                    ForEach(rows) { row in
                                        Text(row.name)
                                            .font(.system(size: 16))
                                            .padding(.leading, 14)
                                            .padding(.trailing, 30)
                                            .padding(.vertical, 8)
                                            .background(
                                                ZStack(alignment: .trailing) {
                                                    Capsule()
                                                        .fill(.ultraThinMaterial)
                                                    Button {
                                                        positiveKeywordViewModel.removeTag(by: row.id)
                                                    } label: {
                                                        Image(systemName: "xmark")
                                                            .frame(width: 15, height: 15)
                                                            .padding(.trailing, 8)
                                                            .foregroundColor(.red)
                                                    }
                                                }
                                            )
                                    }
                                }
                                .frame(height: 28)
                                .padding(.bottom, 10)
                            }
                        }
                        .padding(.top, 20)
                    }
                }
            }
        }
    }
    
    private func determine(keyword: String) {
        isErrorKeyword = false
        
        do {
            try positiveKeywordViewModel.addTag()
            keywordError = nil
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
