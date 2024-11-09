//
//  NetworkError.swift
//  CoreNetworking
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case decoding(_ propertyName: String, _ value: String)
}
