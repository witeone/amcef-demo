//
//  SUIWKWebView.swift
//  polak.amcef.demo
//
//  Created by Marek Polak on 15/02/2023.
//

import WebKit
import SwiftUI

struct SUIWKWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
