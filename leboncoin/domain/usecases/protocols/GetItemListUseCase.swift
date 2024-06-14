//
//  GetItemListUseCase.swift
//  leboncoin
//
//  Created by Didier Nizard on 14/06/2024.
//

import Combine

protocol GetItemListUseCase {
    func execute() -> AnyPublisher<[LBCItem], Error>
}
