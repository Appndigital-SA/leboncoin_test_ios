//
//  ItemRepository.swift
//  leboncoin
//
//  Created by Didier Nizard on 12/06/2024.
//

import Combine

protocol ItemRepository {
    func fetchCategoriesList() -> AnyPublisher<[LBCCategory], Error>
    func fetchItemsList(configuration: LBCConfiguration) -> AnyPublisher<[LBCItem], Error>
}
