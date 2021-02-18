//
//  ApiError.swift
//  Domain
//
//  Created by Michael  on 13/01/21.
//

import Foundation

public enum ApiError: Error, Equatable {
    case parsing(description: String)
    case network(description: String)
}
