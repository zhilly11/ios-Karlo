//  Karlo - AlbumView.swift
//  Created by zhilly on 2023/09/07

import SwiftUI

struct AlbumView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var imageData: [String] = .init()
    @State private var isErrorAlertPresent: Bool = false
    @State private var networkError: NetworkError? = nil
    @State private var isLoadingSuccess: Bool = false
    
    let imageInfo: ImageConfiguration
    private let karlo: KarloAPI = .init(session: URLSession.shared)
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoadingSuccess {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(imageData, id: \.self) { string in
                                if let imageData = Data(base64Encoded: string),
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 300, height: 300)
                                        .contextMenu {
                                            Button(action: {
                                                // TODO: 공유 기능 구현
                                            }) {
                                                Text("공유")
                                                Image(systemName: "square.and.arrow.up")
                                            }
                                            
                                            Button(action: {
                                                // TODO: 저장 기능 구현
                                            }) {
                                                Text("저장")
                                                Image(systemName: "square.and.arrow.down")
                                            }
                                        }
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Image(systemName: "info.circle")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("이미지를 길게 누르면 저장 가능합니다.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                } else {
                    ProgressView() {
                        Text("이미지 생성 중...")
                    }
                    .frame(width: 300, height: 300)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        Text("긍정 제시어 :")
                            .font(.title3)
                            .bold()
                        Text("\(imageInfo.prompt)")
                            .font(.body)
                    }
                    
                    HStack(alignment: .top) {
                        Text("부정 제시어 :")
                            .font(.title3)
                            .bold()
                        Text("\(imageInfo.negativePrompt)")
                            .font(.body)
                    }
                    
                    HStack(alignment: .top) {
                        Text("이미지 크기 :")
                            .font(.title3)
                            .bold()
                        Text("\(imageInfo.width) * \(imageInfo.height) px")
                            .font(.body)
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                
                Spacer()
            }
            .navigationTitle("생성된 이미지")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("닫기") {
                    dismiss()
                }
            }
        }
        .alert(isPresented: $isErrorAlertPresent,
               error: networkError,
               actions: {
            Button("OK", role: .cancel) { }
        })
        .onAppear {
            Task(priority: .medium) {
                do {
                    // Real API Code
//                    let data = try await karlo.generateImage(info: self.imageInfo)
//                    self.imageData = data
//                    self.isLoadingSuccess = true
                    
                    // Sample Data fetch
                    self.imageData = try await SampleData.fetchSampleData()
                    self.isLoadingSuccess = true
                } catch let error as NetworkError{
                    self.networkError = error
                    self.isErrorAlertPresent = true
                }
            }
            
        }
        
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView(imageInfo: SampleData.sampleImageInfo)
    }
}
