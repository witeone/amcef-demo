//
//  EntriesRequest.swift
//  polak.amcef.demo
//
//  Created by Marek Polak on 13/02/2023.
//

import Foundation

// MARK: - EntriesRequest
struct EntriesRequest: Encodable, Equatable {
    var title: String?
    var description: String?
    var auth: String?
    var https: Bool?
    var cors: String?
    var category: String?

    public enum CondingKeys: String, CodingKey {
        case title, description, auth, https, cors, category
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CondingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(auth, forKey: .auth)
        try container.encode(https, forKey: .https)
        try container.encode(cors, forKey: .cors)
        try container.encode(category, forKey: .category)
    }
}
