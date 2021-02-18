//
//  ResponseFactory.swift
//  InfrastructureTests
//
//  Created by Michael  on 18/01/21.
//

import Foundation

final class ResponseFactory {
    static func make(statusCode: Int = 200) -> HTTPURLResponse? {
        guard let url = URLComponentsFactoryTests.makeValidUrlComponents().url else {
            return nil
        }

        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }
}
