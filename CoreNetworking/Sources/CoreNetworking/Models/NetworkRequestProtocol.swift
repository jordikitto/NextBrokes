//
//  NetworkRequestProtocol.swift
//  CoreNetworking
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation

public protocol NetworkRequestProtocol {
    associatedtype Response: Decodable
    
    var path: String { get }
}
