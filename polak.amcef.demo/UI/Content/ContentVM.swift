//
//  ContentVM.swift
//  polak.amcef.demo
//
//  Created by Marek Polak on 13/02/2023.
//

import Foundation
import Combine
import Alamofire

class ContentVM: ObservableObject {
    @Published var items: EntriesResponse?
//    @Published private var storedItems: EntriesResponse?
    @Published var categories: CategoriesResponse?
    @Published var request: EntriesRequest = .init()
    @Published var isLoading = false
    @Published var selectedCategoryFilter: String?
    @Published var searchableText = ""
    @Published var searchForTitles = true
    
    private var bag = Set<AnyCancellable>()

    init() {
        $request
            .removeDuplicates()
            .flatMap { [weak self] request -> AnyPublisher<EntriesResponse, AFError> in
                self?.isLoading = true
                return Networking.shared.getEntries(request: request)
            }
            .sinkToResult { [weak self] result in
                self?.isLoading = false
                switch result {
                case .success(let success):
                    print(success)
                    var result = success
                    if result.entries.count > 40, self?.selectedCategoryFilter == nil {
                        result.entries.removeLast(result.count - 40)
                    }
                    self?.items = result
                    print(result.count)
                case .failure(let failure):
                    // TODO: - fetch data from db
                    print("failed to fetch data \(failure.errorDescription)")
                }
            }
            .store(in: &bag)

        Publishers.CombineLatest($searchableText, $searchForTitles)
            .dropFirst(2)
            .debounce(for: 1.5, scheduler: DispatchQueue.main)
            .sink { [weak self] val in
                if val.1 {
                    self?.request.title = val.0
                } else {
                    self?.request.description = val.0
                }
            }
            .store(in: &bag)

        Networking.shared.getCategories()
            .sinkToResult { [weak self] result in
                switch result {
                case .success(let success):
                    self?.categories = success
                case .failure(let failure):
                    // TODO: - fetch data from db
                    print("failed to fetch data \(failure.errorDescription)")
                }
            }
            .store(in: &bag)
    }
}
