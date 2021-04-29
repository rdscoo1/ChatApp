//
//  PixabayImageRequest.swift
//  ChatApp
//
//  Created by Roman Khodukin on 23.04.2021.
//

import Foundation

class PixabayImageRequest: IRequest {
    
    let urlPath: String
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: urlPath) else {
            return nil
        }
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    }

    init(urlPath: String) {
        self.urlPath = urlPath
    }

}
