//
//  ItemRepositoryImpl.swift
//  leboncoin
//
//  Created by Didier Nizard on 13/06/2024.
//

import Combine

class ItemRepositoryImpl: ItemRepository {
    let apiService: ApiService
    
    init(apiService: ApiService = ApiService()) {
        self.apiService = apiService
    }
    
    func fetchItemList() -> AnyPublisher<[LBCItem], any Error> {
        return apiService
            .fetchCategories()
            .map({ $0.map({ $0.toModel() }) })
            .flatMap({ categories in
                self.apiService
                    .fetchItems()
                    .map({
                        $0.map({ itemDto in
                            itemDto.toModel(category: categories.first(where: { $0.id == itemDto.categoryId }))
                        })
                    })
            })
            .eraseToAnyPublisher()
    }
}
