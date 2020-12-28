//
//  DataDecoder.swift
//  
//
//  Created by Sushant Ubale on 12/28/20.
//

import Foundation
import Combine

public enum SessionError: Error {
    case statusCode(HTTPURLResponse)
}

@available(iOS 13.0, *)
public class DataDecoder {
    public var url: URL?
    
    public init(url: URL) {
        self.url = url
    }
    
    public func dataTaskPublisher<T: Decodable>() -> AnyPublisher<T, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: self.url!)
            .tryMap( { (data, response) -> Data in
                if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) == false {
                    throw SessionError.statusCode(response)
                }
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
