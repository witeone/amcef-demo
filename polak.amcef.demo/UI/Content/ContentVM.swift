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
    @Published var categories: CategoriesResponse?
    @Published var request: EntriesRequest = .init()
    @Published var isLoading = false
    @Published var selectedCategoryFilter: String?
    @Published var searchableText = ""
    @Published var searchForTitles = true

    private let repository = Repository<EntryCD>()
    
    private var bag = Set<AnyCancellable>()

    init() {
        $request
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] request -> AnyPublisher<EntriesResponse, AFError> in
                self?.isLoading = true
                return Networking.shared.getEntries(request: request)
            }
            .sinkToResult { [weak self] result in
                guard let self else { return }

                switch result {
                case .success(let success):
                    var result = success
                    if var entries = result.entries,
                       entries.count > 40,
                       self.selectedCategoryFilter == nil {

                        entries.removeLast(result.count - 40)
                        self.repository.deleteAll().sinkToResult({ _ in }).store(in: &self.bag)

                        for entry in entries {
                            self.repository.add { data in
                                data.desc = entry.description
                                data.category = entry.category
                                data.link = entry.link
                                data.api = entry.api
                                data.auth = entry.auth.rawValue
                                data.https = entry.https
                                data.cors = entry.cors.rawValue
                            }
                            .sinkToResult({ _ in })
                            .store(in: &self.bag)
                        }
                        result.entries = entries
                    }
                    self.isLoading = false
                    self.items = result
                case .failure:
                    if self.selectedCategoryFilter == nil, self.searchableText == "" {
                        print("failed to fetch data, fallback to CoreData")
                        self.repository.fetch()
                            .sinkToResult { result in
                                self.isLoading = false
                                switch result {
                                case .success(let success):
                                    self.items = EntriesResponse(count: success.count,
                                                                 entries: success.compactMap { $0.mirror() })
                                case .failure:
                                    break
                                }
                            }
                            .store(in: &self.bag)
                    } else {
                        self.items?.entries = []
                        self.isLoading = false
                    }
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
                case .failure:
                    print("failed to fetch data")
                }
            }
            .store(in: &bag)
    }

    func restore(with category: String) {
        request = .init(category: category)
    }
}
