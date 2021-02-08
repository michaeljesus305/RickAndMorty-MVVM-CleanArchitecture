//
//  URLSessionAdapter.swift
//  Infrastructure
//
//  Created by Michael  on 06/02/21.
//

import Foundation
import Domain
import Combine
import Data

final class URLSessionAdapter {
    private var session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get<ApiResponse>(with urlComponents: URLComponents, timeoutInterval: TimeInterval = 15.0) -> AnyPublisher<ApiResponse, ApiError> where ApiResponse: Codable {
        guard let url = urlComponents.url else {
            let error = ApiError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }

        let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: timeoutInterval)

        return session.dataTaskPublisher(for: request)
            .mapError { error in
                .network(description: error.localizedDescription)
        }
        .flatMap { pair in
             decode(pair.data)
        }
        .eraseToAnyPublisher()
    }
}
