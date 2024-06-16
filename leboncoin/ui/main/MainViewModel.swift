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
    
    @Injected(\.getItemListUseCaseProvider) var getItemListUseCase: GetItemListUseCase
    @Injected(\.getCategoryListUseCaseProvider) var getCategoryListUseCase: GetCategorieListUseCase
    
    var allItems: [LBCItem] = []
    var configuration = LBCConfiguration()
    
    @Published var items: [LBCItem] = []
    @Published var state: MainLoadingState = .loading
    @Published var categories: [LBCCategory] = []
    
    var onlyUrgent: Bool = false
    
    func fetchCategories() {
        getCategoryListUseCase.execute()
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
              }) { result in
                  self.categories = result
                  self.fetchItems()
            }
            .store(in: &cancellables)
    }
        
    func fetchItems() {
        items = []
        state = .loading
        
        getItemListUseCase.execute(configuration: configuration)
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
                  self.items = items
                  if items.isEmpty {
                      self.state = .empty
                  } else {
                      self.state = .finished
                  }
            }
            .store(in: &cancellables)
    }
    
    func filterBy(_ category: LBCCategory) {
        configuration.selectedCategory = category.id
        fetchItems()
    }
    
    func sortOnlyUrgent(isChecked: Bool) {
        configuration.onlyUrgent = isChecked
        fetchItems()
    }
    
    func sortBy(_ sortType: SortType) {
        configuration.sortType = sortType
        fetchItems()
    }
}
