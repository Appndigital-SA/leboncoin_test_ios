//
//  ItemRepository.swift
//  leboncoin
//
//  Created by Didier Nizard on 12/06/2024.
//

import Combine

protocol ItemRepository {
    func fetchItemList() -> AnyPublisher<[LBCItem], Error>
}
