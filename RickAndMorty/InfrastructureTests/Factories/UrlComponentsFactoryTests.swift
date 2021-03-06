//
//  URLComponentsFactoryTests.swift
//  InfrastructureTests
//
//  Created by Michael  on 17/01/21.
//

import Foundation
import Data

final class URLComponentsFactoryTests {
    static func makeValidUrlComponents() -> URLComponents {
        let query = URLQueryItem(name: "page", value: "1")

        var components = URLComponents()
        components.scheme = Constants.Api.Global.scheme
        components.host = Constants.Api.Global.host
        components.path = Constants.Api.Character.path
        components.queryItems = [query]

        return components
    }

    static func makeUrlComponentsWithInvalidUrl() -> URLComponents? {
        var urlComponents = URLComponents(string: "https://google.com")
        urlComponents?.path = "test/error"

        return urlComponents
    }
}
