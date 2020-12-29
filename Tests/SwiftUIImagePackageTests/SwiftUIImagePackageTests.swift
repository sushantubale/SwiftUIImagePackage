import XCTest
@testable import SwiftUIImagePackage

final class SwiftUIImagePackageTests: XCTestCase {
    @available(iOS 13.0, *)
    func testStartDownloading() {
        
        let imageFetcher = ImageFetcher(url: URL(string: "test_url")!)
        imageFetcher.isLoadingImage = true
        imageFetcher.startDownloading()
        XCTAssertEqual(imageFetcher.isLoadingImage, true)
    }
    
    @available(iOS 13.0, *)
    func testFinishDownloading() {
        let imageFetcher = ImageFetcher(url: URL(string: "test_url")!)
        imageFetcher.isLoadingImage = false
        imageFetcher.finishDownloading()
        XCTAssertEqual(imageFetcher.isLoadingImage, false)

    }
    
    @available(iOS 13.0, *)
    func testDataDecoder() {
        let dataDecoder = DataDecoder(url: URL(string: "test_url")!)
        let urlResponse = URLResponse(url: URL(string: "test_url")!, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
        let response = dataDecoder.getResponse(urlResponse)
        XCTAssertEqual(response, false)
    }
}
