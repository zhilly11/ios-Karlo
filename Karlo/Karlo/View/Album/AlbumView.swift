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
                        Text(Constant.Text.generatingImage)
                    }
                    .frame(width: Constant.Layout.albumImageSize,
                           height: Constant.Layout.albumImageSize)
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewStore.imageData, id: \.self) { data in
                                if let uiImage: UIImage = .init(data: data) {
                                    let generatedImage: Image = .init(uiImage: uiImage)
                                    generatedImage
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: Constant.Layout.albumImageSize,
                                               height: Constant.Layout.albumImageSize)
                                        .contextMenu {
                                            ShareLink(
                                                item: generatedImage,
                                                preview: SharePreview(
                                                    viewStore.imageConfigurationRequest.prompt,
                                                    image: generatedImage)) {
                                                        Text(Constant.Text.share)
                                                        Constant.SystemImage.share
                                                    }
                                            
                                            Button(action: {
                                                viewStore.send(.saveImage(data: data))
                                            }) {
                                                Text(Constant.Text.save)
                                                Constant.SystemImage.save
                                            }
                                        }
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Constant.SystemImage.info
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(Constant.Description.imageSave)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: Constant.Layout.Spacing.medium) {
                    HStack(alignment: .top) {
                        Text(Constant.Text.prompt.convertColonFormat())
                            .font(.title3)
                            .bold()
                            .frame(width: Constant.Layout.largeTextSize, alignment: .trailing)
                        Text(viewStore.imageConfigurationRequest.prompt)
                            .font(.body)
                        Spacer()
                    }
                    
                    HStack(alignment: .top) {
                        Text(Constant.Text.negativePrompt.convertColonFormat())
                            .font(.title3)
                            .bold()
                            .frame(width: Constant.Layout.largeTextSize, alignment: .trailing)
                        Text(viewStore.imageConfigurationRequest.negativePrompt)
                            .font(.body)
                        Spacer()
                    }
                    
                    HStack(alignment: .top) {
                        Text(Constant.Text.imageSize.convertColonFormat())
                            .font(.title3)
                            .bold()
                            .frame(width: Constant.Layout.largeTextSize, alignment: .trailing)
                        Text(Constant.Karlo.convertImageSizeString(
                            width: viewStore.imageConfigurationRequest.width,
                            height: viewStore.imageConfigurationRequest.height)
                        )
                            .font(.body)
                        Spacer()
                    }
                }
                .padding(.top, Constant.Layout.Spacing.small)
                .padding(.leading, Constant.Layout.Spacing.small)
                .padding(.trailing, Constant.Layout.Spacing.small)
                
                Spacer()
            }
            .navigationTitle(Constant.Title.generatedImage)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(Constant.Text.close) {
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
                store: .init(initialState: AlbumFeature.State(imageConfigurationRequest: SampleData.sampleImageInfo)) {
                    AlbumFeature()
                }
            )
        }
    }
}
