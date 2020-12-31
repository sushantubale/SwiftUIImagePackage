//
//  ImageFetcher.swift
//  
//
//  Created by Sushant Ubale on 12/27/20.
//

import Foundation
import UIKit
import Combine

//MARK: - ImageFetcher
/// Description This class is used to fetch single image from a remote server. Also the imageCachening is taken care by using ImageFetcherCacheProtocol.
/// This class also takes care of threading issue because each operation is a seperate url session which is managed by cancellable protocol.

@available(iOS 13.0, *)
class ImageFetcher: ObservableObject {
    
    @Published var image: UIImage?
    var isLoadingImage = false
    private let url: URL
    private var imageFetcherCache: ImageFetcherCacheProtocol?
    private var cancellable: AnyCancellable?
    private static let imageQueue = DispatchQueue(label: "image-processing")
    
    init(url: URL, cache: ImageFetcherCacheProtocol? = nil) {
        self.url = url
        self.imageFetcherCache = cache
    }
    
    deinit {
        self.cancellable?.cancel()
        cancel()
    }
    
    /// load function is used to fetch images and publishes image or images.
    func load() {
        guard !isLoadingImage else { return }

        if let image = imageFetcherCache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in
                            guard let strongSelf = self else { return }
                            strongSelf.startDownloading() },
                          receiveOutput: { [weak self] in
                            guard let strongSelf = self else { return }
                            strongSelf.cacheImage($0) },
                          receiveCompletion: { [weak self] _ in
                            guard let strongSelf = self else { return }
                            strongSelf.finishDownloading() },
                          receiveCancel: { [weak self] in
                            guard let strongSelf = self else { return }
                            strongSelf.finishDownloading() })
            .subscribe(on: Self.imageQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.image = $0 }
    }
    
    /// cancel is used to cancel any task.
    func cancel() {
        cancellable?.cancel()
    }
    
    /// startDownloading is used to show that the loading of a particular task or image has started.
    func startDownloading() {
        isLoadingImage = true
    }
    
    /// finishDownloading is used to show that the loading of a particular task or image has finished.
    func finishDownloading() {
        isLoadingImage = false
    }
    
    /// cacheImage is used to cache the url or url's and adds non-existing url's to imageFetcherCache.
    private func cacheImage(_ image: UIImage?) {
        image.map { imageFetcherCache?[url] = $0 }
    }
}
