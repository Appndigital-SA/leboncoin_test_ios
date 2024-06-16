//
//  GetCategorieListUseCase.swift
//  leboncoin
//
//  Created by Didier Nizard on 16/06/2024.
//

import Combine

protocol GetCategorieListUseCase {
    func execute() -> AnyPublisher<[LBCCategory], Error>
}
