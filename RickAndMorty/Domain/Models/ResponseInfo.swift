//
//  ResponseInfo.swift
//  RickAndMorty
//
//  Created by Michael  on 04/09/20.
//  Copyright © 2020 Michael . All rights reserved.
//

import Foundation

public struct ResponseInfo: Codable {
    let count, pages: Int
    let next: String
    let prev: String?
}
