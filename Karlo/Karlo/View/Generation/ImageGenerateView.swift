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
                    Section(Constant.Title.Section.promptInput) {
                        KeywordInputView(
                            store: self.store.scope(
                                state: \.prompt,
                                action: ImageGenerateFeature.Action.prompt
                            )
                        )
                        .listRowSeparator(.hidden)
                        
                        KeywordTagView(
                            store: self.store.scope(
                                state: \.prompt,
                                action: ImageGenerateFeature.Action.prompt
                            )
                        )
                    }
                    
                    Section(Constant.Title.Section.negativePromptInput) {
                        KeywordInputView(
                            store: self.store.scope(
                                state: \.negativePrompt,
                                action: ImageGenerateFeature.Action.negativePrompt
                            )
                        )
                        .listRowSeparator(.hidden)
                        
                        KeywordTagView(
                            store: self.store.scope(
                                state: \.negativePrompt,
                                action: ImageGenerateFeature.Action.negativePrompt
                            )
                        )
                    }
                    
                    Section(Constant.Title.Section.imageDetail) {
                        HStack(alignment: .center, spacing: 30) {
                            Picker(
                                Constant.Text.width,
                                selection: viewStore.binding(
                                    get: \.imageWidth,
                                    send: ImageGenerateFeature.Action.imageWidthChanged
                                )
                            ) {
                                ForEach(Constant.Karlo.imageSizes, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .pickerStyle(.automatic)
                        }

                        HStack(alignment: .center, spacing: 30) {
                            Picker(
                                Constant.Text.height,
                                selection: viewStore.binding(
                                    get: \.imageHeight,
                                    send: ImageGenerateFeature.Action.imageHeightChanged
                                )
                            ) {
                                ForEach(Constant.Karlo.imageSizes, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .pickerStyle(.automatic)
                        }

                        Toggle(
                            Constant.Text.upscale,
                            isOn: viewStore.binding(
                                get: \.imageUpscale,
                                send: ImageGenerateFeature.Action.imageUpscaleToggle
                            )
                        )
                        .tint(Color.blue)

                        Toggle(
                            Constant.Text.scale,
                            isOn: viewStore.binding(
                                get: \.imageScale,
                                send: ImageGenerateFeature.Action.imageScaleToggle
                            )
                        )
                        .tint(Color.blue)

                        VStack {
                            HStack {
                                Text(Constant.Text.quality.convertColonFormat(with: Int(viewStore.imageQuality)))
                                Spacer()
                            }

                            Slider(
                                value: viewStore.binding(
                                    get: \.imageQuality,
                                    send: ImageGenerateFeature.Action.imageQualityChanged
                                ),
                                in: 1...100,
                                step: 1
                            ) {
                                Text(Constant.Text.quality)
                            } minimumValueLabel: {
                                Text(String(format: "%0.f", Constant.Karlo.imageQualityMinimum))
                            } maximumValueLabel: {
                                Text(String(format: "%0.f", Constant.Karlo.imageQualityMaximum))
                            }
                        }

                        Stepper(
                            Constant.Text.imageCount.convertColonFormat(with: viewStore.imageCount),
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
                            Text(Constant.ButtonTitle.imageGenerate)
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
            .navigationTitle(Constant.Title.imageGenerate)
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
