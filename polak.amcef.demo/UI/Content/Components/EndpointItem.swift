//
//  EndpointItem.swift
//  polak.amcef.demo
//
//  Created by Marek Polak on 15/02/2023.
//

import SwiftUI

struct EndpointItem: View {
    let entry: Entry

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(entry.api)
                    .font(.title2)
                    .bold()

                Text(entry.category)
                    .font(.headline)
                    .bold()

                Text(entry.description)
                    .font(.callout)
            }

            Spacer()

            VStack {
                if entry.https {
                    Text("HTTPS")
                        .font(.footnote)
                        .bold()
                }

                if entry.auth != .empty {
                    Image(systemName: "lock")
                }
            }

            Divider()
        }
    }
}

struct EndpointItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EndpointItem(entry: .init(api: "Title", description: "Description", auth: .apiKey, https: true, cors: .no, link: "", category: "Cats"))
            EndpointItem(entry: .init(api: "Title", description: "Description", auth: .apiKey, https: false, cors: .no, link: "", category: "Cats"))
            EndpointItem(entry: .init(api: "Title", description: "Description", auth: .empty, https: false, cors: .no, link: "", category: "Dogs"))
        }
    }
}
