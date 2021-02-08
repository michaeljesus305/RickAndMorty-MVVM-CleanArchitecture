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
@testable import Infrastructure

final class UrlSessionAdapterTest: XCTestCase {

    func test_call_request_with_url_components() {
        let sut = self.makeSut()

        let urlComponents = URLComponentsFactoryTests.make()

        let result = sut.get(with: urlComponents, timeoutInterval: 20.0).sink { _ in } receiveValue: { (_: Response) in }

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
        XCTAssertEqual(receivedRequest?.timeoutInterval, 20.0)
    }

    func test_call_with_valid_response() {
        let sut = self.makeSut()
        let bundle = Bundle(identifier: "Michael.Infrastructure")!
        let data = getData(from: "location", with: bundle)
        let response = ResponseFactory.make()
        let urlComponents = URLComponentsFactoryTests.make()
        let expectation = XCTestExpectation(description: "Waiting for request")
        let expectedLocation = try? JSONDecoder().decode(Location.self, from: data)

        var receivedLocation: Location?

        URLProtocolStub.response = response
        URLProtocolStub.data = data

        let result = sut.get(with: urlComponents).sink(receiveCompletion: { _ in

        }, receiveValue: { (response: Location) in
            receivedLocation = response
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 1.0)

        XCTAssertNotNil(result)
        XCTAssertEqual(receivedLocation, expectedLocation)
    }

    private func makeSut() -> URLSessionAdapter {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]

        let urlSession = URLSession(configuration: configuration)

        return URLSessionAdapter(session: urlSession)
    }
}
