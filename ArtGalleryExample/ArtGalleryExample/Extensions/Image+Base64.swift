//
//  Image+Base64.swift
//  ArtGalleryExample
//
//  Created by francisco on 07/02/2024.
//

import Foundation
import SwiftUI
import UIKit

extension Image {
    init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        guard let uiImage = UIImage(data: data) else { return nil }
        self = Image(uiImage: uiImage)
    }
}
