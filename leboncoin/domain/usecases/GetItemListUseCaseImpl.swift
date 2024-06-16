//
//  GetItemListUseCaseImpl.swift
//  leboncoin
//
//  Created by Didier Nizard on 13/06/2024.
//

import Combine

class GetItemListUseCaseImpl: GetItemListUseCase {
    @Injected(\.itemRepositoryProvider) var itemRepository: ItemRepository
    
    func execute(configuration: LBCConfiguration) -> AnyPublisher<[LBCItem], Error> {
        return itemRepository.fetchItemsList(configuration: configuration)
    }
}
