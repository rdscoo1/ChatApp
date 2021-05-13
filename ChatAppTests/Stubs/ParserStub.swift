//
//  ParserStub.swift
//  ChatAppTests
//
//  Created by Roman Khodukin on 07.05.2021.
//

import Foundation
@testable import ChatApp

class ParserStub: IParser {
    func parse(data: Data) -> PixabayResponse? {
        return try? JSONDecoder().decode(PixabayResponse.self, from: data)
    }
}
