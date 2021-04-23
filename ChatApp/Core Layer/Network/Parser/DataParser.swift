//
//  DataParser.swift
//  ChatApp
//
//  Created by Roman Khodukin on 23.04.2021.
//

import Foundation

class DataParser<Model: Decodable>: IParser {
    func parse(data: Data) -> Model? {
        return try? JSONDecoder().decode(Model.self, from: data)
    }
}
