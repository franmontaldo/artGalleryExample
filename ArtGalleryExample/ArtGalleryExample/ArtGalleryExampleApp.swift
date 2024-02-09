//
//  ArtGalleryExampleApp.swift
//  ArtGalleryExample
//
//  Created by francisco on 02/02/2024.
//

import SwiftUI
import PresentationLayer
import DataLayer

@main
struct ArtGalleryExampleApp: App {
    let model = ArtGalleryViewModel(service: ArtAPIService(), storage: StorageService())
    
    var body: some Scene {
        WindowGroup {
            ArtGalleryView(viewModel: model)
        }
    }
}
