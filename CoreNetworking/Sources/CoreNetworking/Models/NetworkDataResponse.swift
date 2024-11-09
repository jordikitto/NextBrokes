//
//  NetworkDataResponse.swift
//  CoreNetworking
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation

public struct NetworkDataResponse<Data: Decodable>: Decodable {
    public let message: String?
    public let status: Int
    public let data: Data
}
    
