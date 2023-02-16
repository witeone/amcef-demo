//
//  Request.swift
//  polak.amcef.demo
//
//  Created by Marek Polak on 13/02/2023.
//

import Foundation
import Alamofire
import AnyCodable

enum Request {
    case entries(EntriesRequest)
    case categories
}

extension Request {
    var route: String {
        switch self {
        case .entries:
            return "/entries"
        case .categories:
            return "/categories"
        }
    }

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var headers: HTTPHeaders {
        return [
            "Accept": "application/json"
        ]
    }

    var params: Parameters {
        switch self {
        case .entries(let request):
            return ["title": request.title ?? "",
                    "description": request.description ?? "",
                    "category": request.category ?? ""]
        case .categories:
            return [:]
        }
    }
}
