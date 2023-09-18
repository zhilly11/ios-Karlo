//  Karlo - ImageGenerateView.swift
//  Created by zhilly on 2023/09/13

import SwiftUI
import ComposableArchitecture

struct ImageGenerateView: View {
    private let store: StoreOf<ImageGenerateFeature>
    @ObservedObject private var viewStore: ViewStoreOf<ImageGenerateFeature>
    
    init(store: StoreOf<ImageGenerateFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("긍정 제시어 입력") {
                        KeywordInputView(
                            store: self.store.scope(
                                state: \.prompt,
                                action: ImageGenerateFeature.Action.prompt
                            )
                        )
                    }
                    
                    Section("긍정 제시어") {
                        KeywordTagView(
                            store: self.store.scope(
                                state: \.prompt,
                                action: ImageGenerateFeature.Action.prompt
                            )
                        )
                    }
                    
                    Section("부정 제시어 입력") {
                        KeywordInputView(
                            store: self.store.scope(
                                state: \.negativePrompt,
                                action: ImageGenerateFeature.Action.negativePrompt
                            )
                        )
                    }
                    
                    Section("부정 제시어") {
                        KeywordTagView(
                            store: self.store.scope(
                                state: \.negativePrompt,
                                action: ImageGenerateFeature.Action.negativePrompt
                            )
                        )
                    }
                    
                    Section("이미지 사이즈(단위: 픽셀)") {
                        VStack(alignment: .leading) {
                            Text("너비")
                                .font(.caption)
                            
                            Picker(
                                "너비 사이즈",
                                selection: viewStore.binding(
                                    get: \.imageWidth,
                                    send: ImageGenerateFeature.Action.imageWidthChanged
                                )
                            ) {
                                ForEach(Constant.imageSizes, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("높이")
                                .font(.caption)
                            
                            Picker(
                                "높이 사이즈",
                                selection: viewStore.binding(
                                    get: \.imageHeight,
                                    send: ImageGenerateFeature.Action.imageHeightChanged
                                )
                            ) {
                                ForEach(Constant.imageSizes, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    
                    Section("이미지 확대 여부") {
                        Toggle(
                            "확대",
                            isOn: viewStore.binding(
                                get: \.imageScale,
                                send: ImageGenerateFeature.Action.imageScaleToggle
                            )
                        )
                        .tint(Color.blue)
                    }
                    
                    Section("이미지 저장 품질(기본값: 70)") {
                        VStack {
                            HStack {
                                Text("품질: \(Int(viewStore.imageQuality))")
                            }
                            
                            Slider(
                                value: viewStore.binding(
                                    get: \.imageQuality,
                                    send: ImageGenerateFeature.Action.imageQualityChanged
                                ),
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
                        Stepper(
                            "이미지 수: \(viewStore.imageCount)",
                            value: viewStore.binding(
                                get: \.imageCount,
                                send: ImageGenerateFeature.Action.imageCountChanged
                            ),
                            in: 1...8,
                            step: 1
                        )
                    }
                    
                    Section {
                        Button(action: {
                            viewStore.send(.setSheet(isPresented: true))
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
                .sheet(
                    isPresented: viewStore.binding(
                        get: \.isAlbumViewPresented,
                        send: ImageGenerateFeature.Action.setSheet(isPresented:)
                    )
                ) {
                    let albumFeature = AlbumFeature.State(
                        imageConfiguration: viewStore.state.imageConfiguration ?? SampleData.sampleImageInfo
                    )

                    AlbumView(
                        store: .init(initialState: albumFeature,
                                     reducer: { AlbumFeature() })
                    )
                }
            }
            .navigationTitle("이미지 생성하기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGenerateView(
            store: Store(initialState: ImageGenerateFeature.State(), reducer: {
                ImageGenerateFeature()
            })
        )
    }
}
