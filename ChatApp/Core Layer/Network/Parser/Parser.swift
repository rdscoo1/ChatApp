//
//  Parser.swift
//  ChatApp
//
//  Created by Roman Khodukin on 23.04.2021.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}

class Parser: IParser {
    func parse(data: Data) -> Data? {
        return data
    }
}
