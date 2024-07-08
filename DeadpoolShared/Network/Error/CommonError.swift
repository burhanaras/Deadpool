//
//  CommonError.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import Foundation

enum CommonError: Error{
    case networkError
    case configurationError
}

enum RequestError: Error{
    case malformedUrlError
    case networkError
}
