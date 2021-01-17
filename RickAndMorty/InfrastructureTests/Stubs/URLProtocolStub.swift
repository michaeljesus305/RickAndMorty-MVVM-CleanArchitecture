//
//  URLProtocolStub.swift
//  InfrastructureTests
//
//  Created by Michael  on 17/01/21.
//

import Foundation

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
