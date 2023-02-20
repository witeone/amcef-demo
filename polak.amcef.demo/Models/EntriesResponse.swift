//
//  EntriesResponse.swift
//  polak.amcef.demo
//
//  Created by Marek Polak on 13/02/2023.
//

import Foundation

// MARK: - EntriesResponse
struct EntriesResponse: Codable, Equatable {
    var count: Int
    var entries: [Entry]?
}

// MARK: - Entry
struct Entry: Codable, Hashable {
    var api, description: String
    var auth: Auth
    var https: Bool
    var cors: Cors
    var link: String
    var category: String

    enum CodingKeys: String, CodingKey {
        case api = "API"
        case description = "Description"
        case auth = "Auth"
        case https = "HTTPS"
        case cors = "Cors"
        case link = "Link"
        case category = "Category"
    }
}

enum Auth: String, Codable {
    case apiKey = "apiKey"
    case empty = ""
    case oAuth = "OAuth"
    case userAgent = "User-Agent"
    case xMashapeKey = "X-Mashape-Key"
}

enum Cors: String, Codable {
    case no = "no"
    case unknown = "unknown"
    case unkown = "unkown"
    case yes = "yes"
}

extension EntryCD {
    func mirror() -> Entry? {
        guard let auth = Auth(rawValue: auth ?? ""),
              let cors = Cors(rawValue: cors ?? "") else { return nil }

        return Entry(api: api ?? "",
                     description: desc ?? "",
                     auth: auth,
                     https: https,
                     cors: cors,
                     link: link ?? "",
                     category: category ?? "")
    }
}
