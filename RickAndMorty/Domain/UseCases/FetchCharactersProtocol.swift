//
//  FetchCharactersProtocol.swift
//  Domain
//
//  Created by Michael  on 13/01/21.
//

import Foundation
import Combine

protocol FetchCharactersProtocol {
    func fetchCharacters(in page: Int) -> AnyPublisher<Response, ApiError>
}
