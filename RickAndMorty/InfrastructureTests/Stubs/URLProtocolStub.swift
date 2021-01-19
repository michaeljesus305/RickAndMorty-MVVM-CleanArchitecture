//
//  URLProtocolStub.swift
//  InfrastructureTests
//
//  Created by Michael  on 17/01/21.
//

import Foundation

class URLProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    static var response: HTTPURLResponse?
    static var data: Data?

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

        if let data = URLProtocolStub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        if let response = URLProtocolStub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override open func stopLoading() {}
}
