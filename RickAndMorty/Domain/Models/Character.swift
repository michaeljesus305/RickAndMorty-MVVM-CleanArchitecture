//
//  Character.swift
//  RickAndMorty
//
//  Created by Michael  on 04/09/20.
//  Copyright © 2020 Michael . All rights reserved.
//

import Foundation

public struct Character: Codable {
    public let id: Int
    public let name: String
    public let status: Status
    public let species: Species
    public let type: String
    public let gender: Gender
    public let origin, location: Location
    public let image: String
    public let episode: [String]
    public let url: String
    public let created: String
}
