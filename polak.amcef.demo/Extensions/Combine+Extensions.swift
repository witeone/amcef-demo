//
//  Combine+Extensions.swift
//  polak.amcef.demo
//
//  Created by Marek Polak on 14/02/2023.
//

import Foundation
import Combine

public extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        sink { completion in
            switch completion {
            case .failure(let error):
                result(.failure(error))
            default:
                break
            }
        } receiveValue: { value in
            result(.success(value))
        }
    }
}
