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
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.artworks) { artwork in
                            ArtGallerySectionView(artwork: artwork)
                                .onAppear {
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
    }
    
    private func shouldLoadNextPage(for artwork: ArtworkViewModel) -> Bool {
        guard !isFetchingNextPage else { return false }
        guard let lastArtwork = viewModel.artworks.last else { return false }
        return artwork.id == lastArtwork.id
    }
    
    private func loadNextPage() {
        guard !isFetchingNextPage else { return }
        isFetchingNextPage = true
        viewModel.loadNextPage()
        isFetchingNextPage = false
    }
}


struct ArtGallerySectionView: View {
    @StateObject var artwork: ArtworkViewModel
    
    var body: some View {
        NavigationLink(destination: ArtworkView(artwork: artwork)) {
            VStack(alignment: .leading) {
                if artwork.image == nil {
                    ProgressView("Loading Image...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else if let image = artwork.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                Text("\(artwork.title) by \(artwork.artistDisplay)")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            .padding()
        }
    }
}

//#Preview {
//    ArtGalleryView(viewModel: <#T##ArtGalleryViewModel#>)
//}
