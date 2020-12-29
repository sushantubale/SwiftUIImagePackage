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
//MARK: - ImageFetcherView
/// This view is used to show Image with it's title. We just have to pass a placeholder view, movieView and movie title.

public struct ImageFetcherView<PlaceholderView: View>: View {
    @StateObject private var loader: ImageFetcher
    public let placeholder: PlaceholderView
    public let movieView: (MoviewView) -> MoviewView
    public var title: String = ""
    
    @available(iOS 14.0, *)
    public init(url: URL, @ViewBuilder placeholder: () -> PlaceholderView, @ViewBuilder movieView: @escaping (MoviewView) -> MoviewView, title: String) {
        self.placeholder = placeholder()
        self.movieView = movieView
        self.title = title
        _loader = StateObject(wrappedValue: ImageFetcher(url: url, cache: Environment(\.imageCache).wrappedValue))
    }
    
    public var body: some View {
        //MARK: - body
        /// This view shows placeholder view if there is no image and shows the MovieView if data is available.
        content
            .onAppear(perform: loader.load)
    }
    
    public var content: some View {
        Group {
            if loader.image != nil {
                MoviewView(image: loader.image!, title: title)
            } else {
                placeholder
            }
        }
    }
}

@available(iOS 13.0, *)
//MARK: - MoviewView
/// A Simple View which shows a Image and a Title of the movie
public struct MoviewView: View {
    public  let image: UIImage?
    public let title: String?
    
    public init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
    
    public var body: some View {
        VStack(spacing: 10, content: {
            if let image = image, let title = title {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                Text(verbatim: title)
                    .bold()
                Spacer()

            }
        })
    }
}
