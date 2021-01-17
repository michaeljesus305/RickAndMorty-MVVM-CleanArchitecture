//
//  URLSessionAdapterTest.swift
//  InfrastructureTests
//
//  Created by Michael  on 16/01/21.
//

import XCTest
import Data
import Combine
import Domain

final class URLSessionAdapter {
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get<ApiResponse>(with urlComponents: URLComponents) -> AnyPublisher<ApiResponse, ApiError> where ApiResponse: Codable {
        guard let url = urlComponents.url else {
            let error = ApiError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 15.0)
        
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

class UrlSessionAdapterTest: XCTestCase {

    func test_call_request_with_url_components() {
        let sut = self.makeSut()
        
        let urlComponents = UrlComponentsFactoryTests.makeUrlComponents()
        
        let result = sut.get(with: urlComponents).sink { _ in } receiveValue: { (response: Response) in }
        
        let expectation = XCTestExpectation(description: "Waiting for request")
        
        var receivedRequest: URLRequest?

        URLProtocolStub.observeRequest { request in
            receivedRequest = request
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(receivedRequest?.url, urlComponents.url)
        XCTAssertEqual(receivedRequest?.httpMethod, "GET")
        XCTAssertEqual(receivedRequest?.timeoutInterval, 15.0)
    }
    
    private func makeSut() -> URLSessionAdapter {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        
        let urlSession = URLSession(configuration: configuration)
        
        return URLSessionAdapter(session: urlSession)
    }
}

