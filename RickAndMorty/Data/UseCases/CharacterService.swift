//
//  CharacterService.swift
//  Data
//
//  Created by Michael  on 13/01/21.
//

import Foundation
import Domain
import Combine

final class CharacterService: FetchCharactersProtocol {

    // MARK: - Properties

    private var httpGetClient: HttpGetClient

    // MARK: - Initializers

    init(httpGetClient: HttpGetClient) {
        self.httpGetClient = httpGetClient
    }

    // MARK: - FetchCharactersProtocol functions

    func fetchCharacters(in page: Int) -> AnyPublisher<Response, ApiError> {
        let urlComponents = self.makeUrlComponents(with: String(page))

        return self.httpGetClient.get(with: urlComponents).eraseToAnyPublisher()
    }

    // MARK: - Private functions

    private func makeUrlComponents(with page: String) -> URLComponents {
        let query = URLQueryItem(name: "page", value: page)

        var components = URLComponents()
        components.scheme = Constants.Api.Global.scheme
        components.host = Constants.Api.Global.host
        components.path = Constants.Api.Character.path
        components.queryItems = [query]

        return components
    }
}
