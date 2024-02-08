//
//  ArtGalleryView.swift
//  ArtGalleryExample
//
//  Created by francisco on 02/02/2024.
//

import SwiftUI

struct ArtGalleryView: View {
    @StateObject var viewModel: ArtGalleryViewModel
    @State private var isFetchingNextPage = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.artworks) { artwork in
                        VStack(alignment: .leading) {
                            if artwork.image == nil {
                                ProgressView("Loading Image...")
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            } else if let image = artwork.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                            }
                            Text("\(artwork.title) by \(artwork.artistDisplay)")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .onAppear {
                            // Load next page when the last artwork is about to appear
                            if shouldLoadNextPage(for: artwork) {
                                loadNextPage()
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchArtworks()
            }
        }
    }

    private func shouldLoadNextPage(for artwork: ArtworkViewModel) -> Bool {
        guard !isFetchingNextPage else { return false }
        guard let lastArtwork = viewModel.artworks.last else { return false }
        return artwork.id == lastArtwork.id
    }

    private func loadNextPage() {
        print(isFetchingNextPage)
        guard !isFetchingNextPage else { return }
        isFetchingNextPage = true
        viewModel.loadNextPage()
        isFetchingNextPage = false
    }
}


//#Preview {
//    ArtGalleryView(viewModel: <#T##ArtGalleryViewModel#>)
//}
