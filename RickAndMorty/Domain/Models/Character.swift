//
//  Character.swift
//  RickAndMorty
//
//  Created by Michael  on 04/09/20.
//  Copyright © 2020 Michael . All rights reserved.
//

import Foundation

public struct Character: Codable {
    let id: Int
    let name: String
    let status: Status
    let species: Species
    let type: String
    let gender: Gender
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
