//
//  NSAttributedString+Extension.swift
//  ArtGalleryExample
//
//  Created by francisco on 08/02/2024.
//

import Foundation

extension NSAttributedString {
    convenience init?(htmlString: String) {
        guard let data = htmlString.data(using: .utf8) else { return nil }
        do {
            let attributedString = try NSAttributedString(data: data,
                                                            options: [.documentType: NSAttributedString.DocumentType.html],
                                                            documentAttributes: nil)
            self.init(attributedString: attributedString)
        } catch {
            return nil
        }
    }
}
