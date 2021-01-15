//
//  HttpGetClient.swift
//  Data
//
//  Created by Michael  on 13/01/21.
//

import Foundation
import Domain
import Combine

public protocol HttpGetClient {
    func get<ApiResponse>(with urlComponents: URLComponents) -> AnyPublisher<ApiResponse, ApiError> where ApiResponse: Codable
}
