//
//  String+Extensions.swift
//  CoreDesign
//
//  Created by Jordi Kitto on 11/11/2024.
//

import Foundation

public extension String {
    /// Excludes the string from being detected and added to the String Catalog.
    ///
    /// Use this for strings in Previews.
    var catalogExcluded: String {
        String(self)
    }
}
