//  Karlo - ContentView.swift
//  Created by zhilly on 2023/08/28

import SwiftUI

struct ContentView: View {
    @StateObject private var positiveKeywordViewModel: KeywordViewModel = .init()
    @StateObject private var negativeKeywordViewModel: KeywordViewModel = .init()
    
    @State private var imageWidth: Int = 512
    @State private var imageHeight: Int = 512
    @State private var imageScale: Bool = false
    @State private var imageQuality: Double = 70
    @State private var imageCount: Int = 1
    
    @State private var isAlbumViewPresented: Bool = false
    @State private var isErrorKeyword: Bool = false
    @State private var keywordError: KeywordError? = nil
    
    private var imageSizes: [Int] = [384, 512, 640]
    
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
                
                Section("이미지 확대 여부") {
                    Toggle(isOn: $imageScale) {
                        Text("확대")
                    }
                    .tint(Color.blue)
                }
                
                Section("이미지 저장 품질(기본값: 70)") {
                    VStack {
                        HStack {
                            Text("품질: \(Int(imageQuality))")
                        }
                        
                        Slider(
                            value: $imageQuality,
                            in: 1...100,
                            step: 1
                        ) {
                            Text("품질")
                        } minimumValueLabel: {
                            Text("1")
                        } maximumValueLabel: {
                            Text("100")
                        }
                    }
                }
                
                Section("생성할 이미지 수(기본값: 1, 최대: 8)") {
                    Stepper(value: $imageCount,
                            in: 1...8,
                            step: 1) {
                        Text("이미지 수: \(imageCount)")
                    }
                }
                
                Section {
                    Button(action: {
                        self.isAlbumViewPresented.toggle()
                    }) {
                        Text("이미지 생성하기")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .listRowInsets(EdgeInsets())
                    .sheet(isPresented: $isAlbumViewPresented) {
                        AlbumView(imageInfo: makeImageInfo())
                    }
                }
            }
        }
    }
    
    private func makeImageInfo() -> ImageConfiguration {
        return ImageConfiguration(prompt: positiveKeywordViewModel.exportPrompt(),
                                  negativePrompt: negativeKeywordViewModel.exportPrompt(),
                                  width: imageWidth,
                                  height: imageHeight,
                                  upscale: imageScale,
                                  scale: imageScale ? 2 : 4,
                                  imageQuality: Int(imageQuality),
                                  imageCount: imageCount)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
