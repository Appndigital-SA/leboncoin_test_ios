//
//  MainViewModel.swift
//  leboncoin
//
//  Created by Didier Nizard on 12/06/2024.
//

import Foundation
import Combine

enum MainLoadingState {
    case loading
    case finished
    case error(String)
    case empty
}

class MainViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let getItemListUseCase: GetItemListUseCase
    
    init(useCase: GetItemListUseCase = GetItemListUseCaseImpl()) {
        getItemListUseCase = useCase
    }
    
    @Published var items: [LBCItem] = []
    @Published var state: MainLoadingState = .loading
        
    func fetchItems() {
        items = []
        state = .loading
        
        getItemListUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                  break
                case .failure(let error):
                    if let apiError = error as? ApiError {
                        switch apiError {
                        case .invalidRequestError(let string):
                            self.state = .error(string)
                        case .networkError(let string):
                            self.state = .error(string)
                        case .decodingError(let string):
                            self.state = .error(string)
                        case .generalError(let string):
                            self.state = .error(string)
                        }
                    } else {
                        self.state = .error("Une erreur est survenue")
                    }
                }
              }) { items in
                  self.items = items.sorted(by: { $0.creationDate > $1.creationDate })
                  if items.isEmpty {
                      self.state = .empty
                  } else {
                      self.state = .finished
                  }
            }
            .store(in: &cancellables)
    }
}
