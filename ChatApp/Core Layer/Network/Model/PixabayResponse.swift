//
//  PixabayResponse.swift
//  ChatApp
//
//  Created by Roman Khodukin on 23.04.2021.
//

import Foundation

struct PixabayResponse: Decodable {
    let total: Int?
    let hits: [PixabayImage]?
}

struct PixabayImage: Decodable {
    let previewUrl: String
    let fullUrl: String
    
    enum CodingKeys: String, CodingKey {
        case previewUrl = "previewURL"
        case fullUrl = "webformatURL"
    }
}
