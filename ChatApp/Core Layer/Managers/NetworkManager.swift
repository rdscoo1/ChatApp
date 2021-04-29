//
//  NetworkManager.swift
//  ChatApp
//
//  Created by Roman Khodukin on 23.04.2021.
//

import Foundation

protocol INetworkManager {
    func makeRequest<Model, Parser>(request: IRequest, parser: Parser, completion: @escaping(Result<Model, RequestError>) -> Void) where Parser: IParser, Parser.Model == Model
}

class NetworkManager: INetworkManager {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func makeRequest<Model, Parser>(request: IRequest,
                                    parser: Parser,
                                    completion: @escaping(Result<Model, RequestError>) -> Void) where Model == Parser.Model, Parser: IParser {
        
        guard let urlRequest = request.urlRequest else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.client))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.server))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            if let model = parser.parse(data: data) {
                completion(.success(model))
            } else {
                completion(.failure(.unableToDecode))
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            task.resume()
        }
    }
}
