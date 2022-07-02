//
//  ImageWrapper.swift
//  TwitterLite
//
//  Created by Rahul Singh on 02/07/22.
//

import UIKit


public struct ImageWrapper: Codable {
    public let image: UIImage

    public enum CodingKeys: String, CodingKey {
        case image
    }

    public init(image: UIImage) {
        self.image = image
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: CodingKeys.image)
        guard let image = UIImage(data: data) else {
            throw EncodingeError.decodingFailed
        }

        self.image = image
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let data = image.cache_toData() else {
            throw EncodingeError.encodingFailed
        }

        try container.encode(data, forKey: CodingKeys.image)
    }
}


extension UIImage {
    var hasAlpha: Bool {
        let result: Bool

        guard let alpha = cgImage?.alphaInfo else {
            return false
        }

        switch alpha {
        case .none, .noneSkipFirst, .noneSkipLast:
            result = false
        default:
            result = true
        }

        return result
    }

    func cache_toData() -> Data? {
        return hasAlpha ? pngData() : jpegData(compressionQuality: 1.0)
    }
}
