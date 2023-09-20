//  Karlo - AlbumView.swift
//  Created by zhilly on 2023/09/07

import SwiftUI
import ComposableArchitecture

struct AlbumView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let store: StoreOf<AlbumFeature>
    @ObservedObject private var viewStore: ViewStoreOf<AlbumFeature>
    
    init(store: StoreOf<AlbumFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewStore.proceeding {
                    ProgressView() {
                        Text("이미지 생성 중...")
                    }
                    .frame(width: 300, height: 300)
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewStore.imageData, id: \.self) { data in
                                if let uiImage: UIImage = .init(data: data) {
                                    let generatedImage: Image = .init(uiImage: uiImage)
                                    generatedImage
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 300, height: 300)
                                        .contextMenu {
                                            ShareLink(
                                                item: generatedImage,
                                                preview: SharePreview(
                                                    viewStore.imageConfiguration.prompt,
                                                    image: generatedImage)) {
                                                        Text("공유")
                                                        Image(systemName: "square.and.arrow.up")
                                                    }
                                            
                                            Button(action: {
                                                viewStore.send(.saveImage(data: data))
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
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        Text("긍정 제시어 :")
                            .font(.title3)
                            .bold()
                        Text(viewStore.imageConfiguration.prompt)
                            .font(.body)
                        Spacer()
                    }
                    
                    HStack(alignment: .top) {
                        Text("부정 제시어 :")
                            .font(.title3)
                            .bold()
                        Text(viewStore.imageConfiguration.negativePrompt)
                            .font(.body)
                        Spacer()
                    }
                    
                    HStack(alignment: .top) {
                        Text("이미지 크기 :")
                            .font(.title3)
                            .bold()
                        Text("\(viewStore.imageConfiguration.width) * \(viewStore.imageConfiguration.height) px")
                            .font(.body)
                        Spacer()
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
            .onAppear{
                viewStore.send(.onAppear)
            }
            .alert(
                store: self.store.scope(state: \.$alert, action: { .alert($0) })
            )
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AlbumView(
                store: .init(initialState: AlbumFeature.State(imageConfiguration: SampleData.sampleImageInfo)) {
                    AlbumFeature()
                }
            )
        }
    }
}
