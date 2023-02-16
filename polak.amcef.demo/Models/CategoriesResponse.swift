//
//  CategoriesResponse.swift
//  polak.amcef.demo
//
//  Created by Marek Polak on 15/02/2023.
//

import Foundation

// MARK: - CategoriesResponse
struct CategoriesResponse: Codable {
    let count: Int
    let categories: [String]
}
