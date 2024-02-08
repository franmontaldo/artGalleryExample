//
//  ArtworkView.swift
//  ArtGalleryExample
//
//  Created by francisco on 08/02/2024.
//

import SwiftUI

struct ArtworkView: View {
    @StateObject var artwork: ArtworkViewModel
    
    init(artwork: ArtworkViewModel) {
        _artwork = StateObject(wrappedValue: artwork)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 16) {
                    if artwork.image == nil {
                        ProgressView("Loading Image...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else if let image = artwork.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(artwork.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("by \(artwork.artistDisplay)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                    Text(artwork.description ?? "No description available")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}


//#Preview {
//    ArtworkView()
//}
