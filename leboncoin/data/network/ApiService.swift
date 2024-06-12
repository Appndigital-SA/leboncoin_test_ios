//
//  ApiService.swift
//  leboncoin
//
//  Created by Didier Nizard on 12/06/2024.
//

import Foundation
import Combine

enum ApiError: LocalizedError {
    case invalidRequestError(String)
    case networkError(String)
    case decodingError(String)
    case generalError(String)
}

class ApiService {
    private let rootUrl = "https://raw.githubusercontent.com/leboncoin/paperclip/master/"
    
    func fetchItems() -> AnyPublisher<[LBCItemDto], Error> {
        guard let listingUrl = URL(string: rootUrl + "listing.json") else {
            return Fail(error: ApiError.invalidRequestError("Wrong url"))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: listingUrl)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw ApiError.networkError("Response error")
                }
                return element.data
              }
            .tryMap { data -> [LBCItemDto] in
              let decoder = JSONDecoder()
              do {
                return try decoder.decode([LBCItemDto].self,
                                          from: data)
              } catch DecodingError.dataCorrupted(_) {
                  throw ApiError.decodingError("Data corrupted")
              } catch let DecodingError.keyNotFound(key, _) {
                  throw ApiError.decodingError("Key '\(key)' not found")
              } catch let DecodingError.valueNotFound(value, _) {
                  throw ApiError.decodingError("Value '\(value)' not found")
              } catch let DecodingError.typeMismatch(type, _)  {
                  throw ApiError.decodingError("Type '\(type)' mismatch")
              } catch {
                  throw ApiError.generalError("Something went wrong")
              }
            }
            .eraseToAnyPublisher()
    }
}
