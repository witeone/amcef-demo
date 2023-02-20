//
//  ContentView.swift
//  polak.amcef.demo
//
//  Created by Marek Polak on 13/02/2023.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @ObservedObject var viewModel: ContentVM

    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView("Loading")
            } else {
                if let entry = viewModel.items {
                    VStack {
                        if let items = entry.entries, !items.isEmpty {
                            List {
                                ForEach(items, id: \.self) { item in
                                    if let url = URL(string: item.link) {
                                        NavigationLink {
                                            SUIWKWebView(url: url)
                                                .navigationTitle(item.api)
                                        } label: {
                                            EndpointItem(entry: item)
                                        }
                                    }
                                }
                            }
                        } else {
                            Text("Text \(viewModel.searchableText) not found")
                        }
                    }
                    .searchable(text: $viewModel.searchableText)
                    .navigationTitle("API List")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(viewModel.searchForTitles ? "Title" : "Desc") {
                                viewModel.searchForTitles.toggle()
                            }
                        }
                        if let categories = viewModel.categories?.categories {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Menu {
                                    HStack {
                                        Button {
                                            viewModel.restore(with: "")
                                        } label: {
                                            HStack {
                                                Text("All")

                                                if viewModel.request.category == nil {
                                                    Image(systemName: "checkmark.circle")
                                                }
                                            }
                                        }
                                        ForEach(categories, id: \.self) { item in
                                            Button {
                                                viewModel.restore(with: item)
                                            } label: {
                                                HStack {
                                                    Text(item)

                                                    if viewModel.request.category == item {
                                                        Image(systemName: "checkmark.circle")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    Image(systemName: "slider.horizontal.3")
                                }
                            }
                        }
                    }
                } else {
                    Text("No data available")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init())
    }
}
