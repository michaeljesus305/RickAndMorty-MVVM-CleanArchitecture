//
//  HttpGetSpy.swift
//  RickAndMorty
//
//  Created by Michael  on 14/01/21.
//

import Foundation
import Domain
import Data
import Combine

final class HttpGetSpy: HttpGetClient {
    var urlComponents: URLComponents?
    var getCallsCount = 0
    var fileName = String()

    func get<ApiResponse>(with urlComponents: URLComponents) -> AnyPublisher<ApiResponse, ApiError> where ApiResponse: Decodable, ApiResponse: Encodable {
        self.urlComponents = urlComponents
        self.getCallsCount += 1

        let bundle = Bundle(identifier: "Michael.Data")!

        let data = getData(from: fileName, with: bundle)

        return decode(data)
    }
}
