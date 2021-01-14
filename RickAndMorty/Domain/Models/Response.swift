//
//  Response.swift
//  RickAndMorty
//
//  Created by Michael  on 04/09/20.
//  Copyright © 2020 Michael . All rights reserved.
//

import Foundation

struct Response: Codable {
    let info: ResponseInfo
    let results: [Character]
}
