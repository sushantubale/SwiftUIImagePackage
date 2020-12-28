//
//  ImageFetcherCache.swift
//  
//
//  Created by Sushant Ubale on 12/27/20.
//

import Foundation
import UIKit

protocol ImageFetcherCacheProtocol {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct ImageFetcherCache: ImageFetcherCacheProtocol {
    private let imageCache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { imageCache.object(forKey: key as NSURL) }
        set { newValue == nil ? imageCache.removeObject(forKey: key as NSURL) : imageCache.setObject(newValue!, forKey: key as NSURL) }
    }
}
