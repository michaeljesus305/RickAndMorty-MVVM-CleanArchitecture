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
    var teste = ""
    
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

    func test_call_url_session_with_url_components() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        
        let urlSession = URLSession(configuration: configuration)
        
        let sut = URLSessionAdapter(session: urlSession)
        
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
}

class URLProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    
    static func observeRequest(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
    }
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override open func startLoading() {
        URLProtocolStub.emit?(request)
    }

    override open func stopLoading() {}
}

