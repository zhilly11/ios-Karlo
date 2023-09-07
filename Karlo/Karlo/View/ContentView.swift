//  Karlo - ContentView.swift
//  Created by zhilly on 2023/08/28

import SwiftUI

struct ContentView: View {
    @StateObject var positiveKeywordViewModel: KeywordViewModel = .init()
    @StateObject var negativeKeywordViewModel: KeywordViewModel = .init()
    @State private var isErrorKeyword: Bool = false
    @State private var keywordError: KeywordError? = nil
    @State var imageWidth: Int = 512
    @State var imageHeight: Int = 512
    
    var imageSizes: [Int] = [384, 512, 640]
    
    var body: some View {
        VStack {
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
                
                Section("이미지 사이즈(단위: 픽셀)") {
                    VStack(alignment: .leading) {
                        Text("너비")
                            .font(.caption)
                        
                        Picker("너비 사이즈", selection: $imageWidth) {
                            ForEach(imageSizes, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("높이")
                            .font(.caption)
                        
                        Picker("높이 사이즈", selection: $imageHeight) {
                            ForEach(imageSizes, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                Section {
                    Button(action: {
                        // TODO: 이미지 생성 뷰로 이동
                        // TODO: ImageInfo 만들어서 넘겨주기
                    }) {
                        Text("이미지 생성하기")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .listRowInsets(EdgeInsets())
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
