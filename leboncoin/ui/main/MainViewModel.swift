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
    
    var allItems: [LBCItem] = []
    var configuration = LBCConfiguration()
    
    @Published var items: [LBCItem] = []
    @Published var state: MainLoadingState = .loading
    @Published var categories: [LBCCategory] = [LBCCategory(id: 0, name: "Tous")]
    
    var onlyUrgent: Bool = false
        
    func fetchItems() {
        items = []
        state = .loading
        categories = [LBCCategory(id: 0, name: "Tous")]
        
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
                  self.allItems = items.sorted(by: { $0.creationDate > $1.creationDate })
                  self.publishItems()
                  
                  self.categories += self.allItems.filter({ $0.category != nil }).map({ $0.category! }).unique().sorted(by: { $0.id < $1.id })
                  
                  if items.isEmpty {
                      self.state = .empty
                  } else {
                      self.state = .finished
                  }
            }
            .store(in: &cancellables)
    }
    
    func publishItems() {
        var itemsToPublish: [LBCItem] = []
        if configuration.selectedCategory == 0 {
            itemsToPublish = allItems
        } else {
            itemsToPublish = allItems.filter({ $0.category?.id == configuration.selectedCategory })
        }
        
        switch configuration.sortType {
        case .dateAsc:
            itemsToPublish.sort(by: { $0.creationDate < $1.creationDate })
        case .dateDesc:
            itemsToPublish.sort(by: { $0.creationDate > $1.creationDate })
        case .priceAsc:
            itemsToPublish.sort(by: { $0.price < $1.price })
        case .priceDesc:
            itemsToPublish.sort(by: { $0.price > $1.price })
        }
        
        if configuration.onlyUrgent {
            itemsToPublish = itemsToPublish.filter({ $0.isUrgent })
        }
        
        items = itemsToPublish
    }
    
    func filterBy(_ category: LBCCategory) {
        configuration.selectedCategory = category.id
        publishItems()
    }
    
    func sortOnlyUrgent(isChecked: Bool) {
        configuration.onlyUrgent = isChecked
        publishItems()
    }
    
    func sortBy(_ sortType: SortType) {
        configuration.sortType = sortType
        publishItems()
    }
}
