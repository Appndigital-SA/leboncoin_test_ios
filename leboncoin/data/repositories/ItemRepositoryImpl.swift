//
//  ItemRepositoryImpl.swift
//  leboncoin
//
//  Created by Didier Nizard on 13/06/2024.
//

import Combine

class ItemRepositoryImpl: ItemRepository {
    @Injected(\.apiServiceProvider) var apiService: ApiService
    
    var cacheCategories: [LBCCategory] = []
    var cacheItems: [LBCItem] = []
    
    func fetchCategoriesList() -> AnyPublisher<[LBCCategory], any Error> {
        if !cacheCategories.isEmpty {
            return Just(cacheCategories)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return apiService
                .fetchCategories()
                .map({ [LBCCategory(id: 0, name: "Tous")] +  $0.map { $0.toModel() } })
                .handleEvents(receiveOutput: {
                    self.cacheCategories = $0
                  })
                .eraseToAnyPublisher()
        }
    }
    
    func fetchItemsList(configuration: LBCConfiguration) -> AnyPublisher<[LBCItem], any Error> {
        if !cacheItems.isEmpty {
            return filterWith(configuration, items: cacheItems)
        } else {
            return apiService
                .fetchItems()
                .map({
                    $0.map({ itemDto in
                        itemDto.toModel(category: self.cacheCategories.first(where: { $0.id == itemDto.categoryId }))
                    })
                })
                .handleEvents(receiveOutput: {
                    self.cacheItems = $0
                  })
                .flatMap({
                    self.filterWith(configuration, items: $0)
                })
                .eraseToAnyPublisher()
        }
    }
    
    private func filterWith(_ configuration: LBCConfiguration, items: [LBCItem]) -> AnyPublisher<[LBCItem], any Error> {
        var itemsToPublish: [LBCItem] = []
        if configuration.selectedCategory == 0 {
            itemsToPublish = cacheItems
        } else {
            itemsToPublish = cacheItems.filter({ $0.category?.id == configuration.selectedCategory })
        }
        
        if configuration.onlyUrgent {
            itemsToPublish = itemsToPublish.filter({ $0.isUrgent })
        }
        
        return Just(
            itemsToPublish.sortedBy(configuration.sortType)
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
}
