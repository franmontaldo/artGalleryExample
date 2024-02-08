//
//  ArtGalleryView.swift
//  ArtGalleryExample
//
//  Created by francisco on 02/02/2024.
//

import SwiftUI

public struct ArtGalleryView: View {
    @StateObject var viewModel: ArtGalleryViewModel
    @State private var isFetchingNextPage = false
    
    public init(viewModel: ArtGalleryViewModel, isFetchingNextPage: Bool = false) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _isFetchingNextPage = State(wrappedValue: isFetchingNextPage)
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    if viewModel.artworks.isEmpty {
                        RefreshLoaderView()
                            .frame(height: UIScreen.main.bounds.size.height * 0.1)
                    }
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
                    .refreshable {
                        viewModel.refreshArtworks()
                    }
                    .disabled(viewModel.artworks.isEmpty)
                    .onAppear {
                        viewModel.fetchArtworks()
                    }
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

public struct ArtGallerySectionView: View {
    @StateObject var artwork: ArtworkViewModel
    
    public var body: some View {
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

public struct RefreshLoaderView: View {
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray.edgesIgnoringSafeArea(.all)
                ProgressView()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

//#Preview {
//    ArtGalleryView(viewModel: <#T##ArtGalleryViewModel#>)
//}
