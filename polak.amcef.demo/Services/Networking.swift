//
//  Networking.swift
//  polak.amcef.demo
//
//  Created by Marek Polak on 13/02/2023.
//

import Foundation
import Alamofire
import Combine

protocol NetworkAPIProtocol {
    func getEntries(request: EntriesRequest) -> AnyPublisher<EntriesResponse, AFError>
    func getCategories() -> AnyPublisher<CategoriesResponse, AFError>
}

class Networking: NetworkAPIProtocol {
    public static let shared = Networking()

    private init() { }

    private static let url = "https://api.publicapis.org"

    // MARK: - get entries
    func getEntries(request: EntriesRequest) -> AnyPublisher<EntriesResponse, AFError> {
        call(request: .entries(request))
    }

    // MARK: - get categories
    func getCategories() -> AnyPublisher<CategoriesResponse, AFError> {
        call(request: .categories)
    }

    private func call<Value: Decodable>(request: Request) -> AnyPublisher<Value, AFError> {
        var url = URLComponents(string: Networking.url + request.route)
        if !request.params.isEmpty {
            url?.queryItems = request.params.map { URLQueryItem(name: $0.key, value: "\($0.value)")  }
        }
        guard let url else { return Fail(error: AFError.invalidURL(url: Networking.url + request.route)).eraseToAnyPublisher() }

        return AF.request(url, method: request.method, encoding: JSONEncoding.default, headers: request.headers)
            .validate()
            .cURLDescription(calling: { desc in
                print(desc)
            })
            .responseDecodable(of: Value.self) { data in
                debugPrint(data)
            }
            .publishDecodable(type: Value.self)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
