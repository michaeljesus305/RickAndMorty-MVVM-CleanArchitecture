//
//  GlobalFunctions.swift
//  Data
//
//  Created by Michael  on 13/01/21.
//

import Foundation
import Combine
import Domain

public func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, ApiError> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970

    return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
            .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}

public func getData(from jsonFile: String, with bundle: Bundle = Bundle.main) -> Data {
    if let jsonUrl = bundle.url(forResource: jsonFile, withExtension: "json") {
        do {
            let data = try Data(contentsOf: jsonUrl)

            return data
        } catch {
            return Data()
        }
    }

    return Data()
}
