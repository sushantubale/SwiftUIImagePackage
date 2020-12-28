//
//  ImageFetcher.swift
//  
//
//  Created by Sushant Ubale on 12/27/20.
//

import Foundation
import UIKit
import Combine

@available(iOS 13.0, *)
class ImageFetcher: ObservableObject {
    @Published var image: UIImage?
    
    private(set) var isLoadingImage = false
    
    private let url: URL
    private var imageFetcherCache: ImageFetcherCacheProtocol?
    private var cancellable: AnyCancellable?
    
    private static let imageQueue = DispatchQueue(label: "image-processing")
    
    init(url: URL, cache: ImageFetcherCacheProtocol? = nil) {
        self.url = url
        self.imageFetcherCache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoadingImage else { return }

        if let image = imageFetcherCache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.startDownloading() },
                          receiveOutput: { [weak self] in self?.cacheImage($0) },
                          receiveCompletion: { [weak self] _ in self?.finishDownloading() },
                          receiveCancel: { [weak self] in self?.finishDownloading() })
            .subscribe(on: Self.imageQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func startDownloading() {
        isLoadingImage = true
    }
    
    private func finishDownloading() {
        isLoadingImage = false
    }
    
    private func cacheImage(_ image: UIImage?) {
        image.map { imageFetcherCache?[url] = $0 }
    }
}
