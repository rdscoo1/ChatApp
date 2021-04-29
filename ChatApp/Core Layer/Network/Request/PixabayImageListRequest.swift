//
//  PixabayImageListRequest.swift
//  ChatApp
//
//  Created by Roman Khodukin on 23.04.2021.
//

import Foundation

class PixabayImageListRequest: IRequest {
        
    private let baseUrl = "https://pixabay.com/api/"
    
    private static var apiKey: String? {
        Bundle.main.object(forInfoDictionaryKey: "PixabayAPIKey") as? String
    }
    
    private let perPage: Int
    
    private let imageType = "photo"
    
    init(perPage: Int) {
        self.perPage = perPage
    }
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = []
        urlComponents?.queryItems?.append(.init(name: "key", value: PixabayImageListRequest.apiKey))
        urlComponents?.queryItems?.append(.init(name: "image_type", value: imageType))
        urlComponents?.queryItems?.append(.init(name: "per_page", value: "\(perPage)"))
        
        guard let url = urlComponents?.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
}
