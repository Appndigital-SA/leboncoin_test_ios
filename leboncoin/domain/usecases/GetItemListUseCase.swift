//
//  GetItemListUseCase.swift
//  leboncoin
//
//  Created by Didier Nizard on 13/06/2024.
//

import Combine

class GetItemListUseCase {
    private let itemRepository: ItemRepository
        
    init(itemRepository: ItemRepository = ItemRepositoryImpl()) {
        self.itemRepository = itemRepository
    }
    
    func execute() -> AnyPublisher<[LBCItem], Error> {
        return itemRepository.fetchItemList()
    }
}
