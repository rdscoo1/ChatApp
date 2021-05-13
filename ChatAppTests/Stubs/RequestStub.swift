//
//  RequestStub.swift
//  ChatAppTests
//
//  Created by Roman Khodukin on 14.05.2021.
//

import Foundation
@testable import ChatApp

class RequestStub: IRequest {
    
    // MARK: - Private Properties
    
    private let apiKey = "12345"
    private(set) var perPage = 1
    private let imageType = "photo"
    
    // MARK: - IRequest Conformance
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = Constants.baseUrl
        urlComponents.path = "/api/"
        urlComponents.queryItems = []
        urlComponents.queryItems?.append(.init(name: "key", value: apiKey))
        urlComponents.queryItems?.append(.init(name: "image_type", value: imageType))
        urlComponents.queryItems?.append(.init(name: "per_page", value: "\(perPage)"))
        
        guard let url = urlComponents.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
}
