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
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView("Loading")
            } else {
                if let items = viewModel.items {
                    List {
                        ForEach(items.entries, id: \.self) { item in
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
                    .navigationTitle("API List")
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(text: $viewModel.searchableText)
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
                                            viewModel.request.category = nil
                                        } label: {
                                            HStack {
                                                Text("All")

                                                if viewModel.request.category == nil {
                                                    Image(systemName: "checkmark.circle")
                                                        .foregroundColor(.green)
                                                }
                                            }
                                        }
                                        ForEach(categories, id: \.self) { item in
                                            Button {
                                                viewModel.request.category = item
                                            } label: {
                                                HStack {
                                                    Text(item)

                                                    if viewModel.request.category == item {
                                                        Image(systemName: "checkmark.circle")
                                                            .foregroundColor(.green)
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

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        ContentView(viewModel: .init())
    }
}
