//
//  EnviromentKeysHelper.swift
//  
//
//  Created by Sushant Ubale on 12/27/20.
//

import Foundation
import SwiftUI

//MARK: - ImageFetcherCacheKey
/// This struct is used to set values in the Cache
private struct ImageFetcherCacheKey: EnvironmentKey {
    static public let defaultValue: ImageFetcherCacheProtocol = ImageFetcherCache()
}

@available(iOS 13.0, *)
extension EnvironmentValues {
    var imageCache: ImageFetcherCacheProtocol {
        get { self[ImageFetcherCacheKey.self] }
        set { self[ImageFetcherCacheKey.self] = newValue }
    }
}
