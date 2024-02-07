//
//  ArtGalleryView.swift
//  ArtGalleryExample
//
//  Created by francisco on 02/02/2024.
//

import SwiftUI

struct ArtGalleryView: View {
    @StateObject var viewModel = ArtGalleryViewModel(artAPIService: ArtAPIService())
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if !viewModel.artworks.isEmpty {
                ScrollView {
                    ForEach(viewModel.artworks) { artwork in
                        VStack(alignment: .leading) {
                            if let thumbnail = artwork.thumbnail {
                                thumbnail
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                            }
                            
                            Text("\(artwork.title) by \(artwork.artistDisplay)")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.top, 20)
            } else {
                Text("Loading...")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.fetchArtworks()
        }
    }
}


//#Preview {
//    ArtGalleryView(viewModel: <#T##ArtGalleryViewModel#>)
//}
