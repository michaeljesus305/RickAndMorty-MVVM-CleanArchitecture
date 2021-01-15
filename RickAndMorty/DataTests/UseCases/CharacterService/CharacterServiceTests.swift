//
//  CharacterServiceTests.swift
//  DataTests
//
//  Created by Michael  on 13/01/21.
//

import XCTest
import Combine
import Domain

@testable import Data

class CharacterServiceTests: XCTestCase {
    
    private lazy var httpGetSpy = HttpGetSpy()
    
    private lazy var sut: CharacterService = {
        return CharacterService(httpGetClient: httpGetSpy)
    }()
    
    private var expectation = XCTestExpectation(description: "Wait Publisher Expectation")
    
    func test_call_get_http_client_with_url_components() {
        httpGetSpy.fileName = "characters"
        
        _ = self.sut.fetchCharacters(in: 1)
        
        do {
            let urlComponents = try XCTUnwrap(httpGetSpy.urlComponents)
            XCTAssertEqual(urlComponents.scheme, "https")
            XCTAssertEqual(urlComponents.host, "rickandmortyapi.com")
            XCTAssertEqual(urlComponents.query, "page=1")
            XCTAssertEqual(urlComponents.path, "/api/character")
            XCTAssertEqual(httpGetSpy.getCallsCount, 1)
        } catch {
            XCTFail("httpGetSpy.urlComponents can't be nil")
        }
    }
    
    func test_call_get_http_client_returns_success() {
        httpGetSpy.fileName = "characters"
        
        var characters = [Character]()
        _ = self.sut.fetchCharacters(in: 1)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { value in
                if value.results.count < 1 {
                    return
                }
                
                characters.append(contentsOf: value.results)
                
                self.expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 1.0)
        
        let firstCharacter = characters.first
        
        XCTAssertEqual(characters.count, 2)
        XCTAssertEqual(firstCharacter?.name, "Rick Sanchez")
        XCTAssertEqual(firstCharacter?.id, 1)
        XCTAssertEqual(firstCharacter?.status, .alive)
        XCTAssertEqual(firstCharacter?.species, .human)
        XCTAssertEqual(firstCharacter?.name, "Rick Sanchez")
        XCTAssertEqual(firstCharacter?.gender, .male)
        XCTAssertEqual(firstCharacter?.origin.name, "Earth (C-137)")
        XCTAssertEqual(firstCharacter?.location.name, "Earth (Replacement Dimension)")
    }
    
    func test_call_get_http_client_with_error() {
        httpGetSpy.fileName = "error"
        
        var error: ApiError?
        
        _ = self.sut.fetchCharacters(in: 1)
            .sink(receiveCompletion: { callbackError in
                switch callbackError {
                case .failure(let apiError):
                    error = apiError
                    self.expectation.fulfill()
                case .finished:
                    XCTFail("call should result in fail")
                }
            }, receiveValue: { _ in
                self.expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(error)
    }
}

