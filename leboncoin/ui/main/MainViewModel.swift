//
//  MainViewModel.swift
//  leboncoin
//
//  Created by Didier Nizard on 12/06/2024.
//

import Foundation
import Combine

class MainViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let apiService = ApiService()
    
    @Published var items: [LBCItem] = []
        
    func fetchItems() {
        apiService.fetchItems()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                  break
                case .failure(let error):
                    if let apiError = error as? ApiError {
                        switch apiError {
                        case .invalidRequestError(let string):
                            print(string)
                        case .networkError(let string):
                            print(string)
                        case .decodingError(let string):
                            print(string)
                        case .generalError(let string):
                            print(string)
                        }
                    }
                }
              }) { items in
                  self.items = items.map({ $0.toModel() }).sorted(by: { $0.creationDate > $1.creationDate })
            }
            .store(in: &cancellables)
    }
}
