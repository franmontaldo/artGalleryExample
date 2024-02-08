//
//  String+Extension.swift
//  ArtGalleryExample
//
//  Created by francisco on 08/02/2024.
//

import Foundation

extension String {
    init(htmlString: String) {
        self = htmlString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

