//
//  GetCategorieListUseCaseImpl.swift
//  leboncoin
//
//  Created by Didier Nizard on 16/06/2024.
//

import Combine

class GetCategorieListUseCaseImpl: GetCategorieListUseCase {
    @Injected(\.itemRepositoryProvider) var itemRepository: ItemRepository
    
    func execute() -> AnyPublisher<[LBCCategory], Error> {
        return itemRepository.fetchCategoriesList()
    }
}
