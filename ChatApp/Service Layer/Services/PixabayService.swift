//
//  PixabayService.swift
//  ChatApp
//
//  Created by Roman Khodukin on 23.04.2021.
//

import Foundation

protocol IPixabayService {
    func getImageListUrls(completion: @escaping((Result<[PixabayImage], RequestError>) -> Void))
    
    func loadImage(urlPath: String, completion: @escaping((Result<Data, RequestError>) -> Void))
}

class PixabayService: IPixabayService {
    
    let networkManager: INetworkManager
    let perPage: Int
    
    init(networkManager: INetworkManager, perPage: Int = 100) {
        self.networkManager = networkManager
        self.perPage = perPage
    }
    
    func getImageListUrls(completion: @escaping((Result<[PixabayImage], RequestError>) -> Void)) {
        networkManager.makeRequest(request: PixabayImageListRequest(perPage: perPage),
                                   parser: DataParser<PixabayResponse>()) { (result) in
            switch result {
            case .success(let searchResponse):
                let model = searchResponse.hits?.compactMap { PixabayImage(previewUrl: $0.previewUrl,
                                                                           fullUrl: $0.fullUrl) } ?? []
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadImage(urlPath: String, completion: @escaping ((Result<Data, RequestError>) -> Void)) {
        networkManager.makeRequest(request: PixabayImageRequest(urlPath: urlPath),
                                   parser: Parser(), completion: completion)
    }
}
