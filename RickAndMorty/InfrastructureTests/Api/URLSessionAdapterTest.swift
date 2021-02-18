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

    func test_call_request_with_valid_url_components() {
        let sut = self.makeSut()

        let urlComponents = URLComponentsFactoryTests.makeValidUrlComponents()

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
        let urlComponents = URLComponentsFactoryTests.makeValidUrlComponents()
        let expectation = XCTestExpectation(description: "Waiting for request")
        let expectedLocation = try? JSONDecoder().decode(Location.self, from: data)

        var receivedLocation: Location?

        URLProtocolStub.response = response
        URLProtocolStub.data = data

        let result = sut.get(with: urlComponents).sink(receiveCompletion: { completion in
            print(completion)
            expectation.fulfill()
        }, receiveValue: { (response: Location) in
            receivedLocation = response

        })

        wait(for: [expectation], timeout: 1.0)

        XCTAssertNotNil(result)
        XCTAssertEqual(receivedLocation, expectedLocation)
    }

    func test_call_request_with_invalid_url_components() {
        let sut = self.makeSut()
        var receivedError: ApiError?
        let expectedError = ApiError.network(description: "Couldn't create URL")

        let urlComponents = URLComponentsFactoryTests.makeUrlComponentsWithInvalidUrl()!

        let expectation = XCTestExpectation(description: "Waiting for request")

        _ = sut.get(with: urlComponents).sink(receiveCompletion: { (error) in
            switch error {
            case .failure(let error):
                receivedError = error
                expectation.fulfill()
            default: XCTFail("Should result in failure")
            }
        }, receiveValue: { (_: Location) in })

        wait(for: [expectation], timeout: 1.0)

        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedError, expectedError)
    }

    private func makeSut() -> URLSessionAdapter {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]

        let urlSession = URLSession(configuration: configuration)

        return URLSessionAdapter(session: urlSession)
    }
}
