//
//  ImageFetcherView.swift
//  
//
//  Created by Sushant Ubale on 12/27/20.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
@available(iOS 14.0, *)
public struct ImageFetcherView<PlaceholderView: View>: View {
    @StateObject private var loader: ImageFetcher
    public let placeholder: PlaceholderView
    public let image: (UIImage) -> Image
    
    @available(iOS 14.0, *)
    public init(url: URL, @ViewBuilder placeholder: () -> PlaceholderView, @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)) {
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageFetcher(url: url, cache: Environment(\.imageCache).wrappedValue))
    }
    
    public var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    public var content: some View {
        Group {
            if loader.image != nil {
                image(loader.image!)
            } else {
                placeholder
            }
        }
    }
}

