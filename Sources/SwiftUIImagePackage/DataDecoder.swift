//
//  DataDecoder.swift
//  
//
//  Created by Sushant Ubale on 12/28/20.
//

import Foundation
import Combine

//MARK: -  SessionError
/// Session error 
public enum SessionError: Error {
    case statusCode(URLResponse)
}

//MARK: - DataDecoder
/// Decoder class which takes in any url and returns back the decoded data based on the Decodable model passed.
@available(iOS 13.0, *)
public class DataDecoder {
    public var url: URL?
    
    public init(url: URL) {
        self.url = url
    }
    
    /// This function calls the API to fetch data from remote server
    /// - Returns: Returns the decoded data done by using JSONDecoder().decode()
    public func dataTaskPublisher<T: Decodable>() -> AnyPublisher<T, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: self.url!)
            .tryMap( { (data, response) -> Data in
                if self.getResponse(response) {
                    throw SessionError.statusCode(response)
                }
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getResponse(_ response: URLResponse?) -> Bool {
        if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) == false {
            return true
        }
        return false
    }
}
