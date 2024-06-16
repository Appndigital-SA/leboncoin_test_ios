//
//  MainViewModelTests.swift
//  leboncoinTests
//
//  Created by Didier Nizard on 14/06/2024.
//

import XCTest
import Combine
@testable import leboncoin

class MainViewModelTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    class GetItemListUseCaseMock: GetItemListUseCase {
        func execute(configuration: leboncoin.LBCConfiguration) -> AnyPublisher<[leboncoin.LBCItem], any Error> {
            return Just(MockEntities.mockItems)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    class GetCategorieListUseCaseMock: GetCategorieListUseCase {
        func execute() -> AnyPublisher<[leboncoin.LBCCategory], any Error> {
            return Just(MockEntities.mockCategories)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func test_whenUseCaseRetrievesItems_thenViewModelContainsSame() {
        let expectation = expectation(description: "Wait for items")
        
        InjectedValues[\.getItemListUseCaseProvider] = GetItemListUseCaseMock()
        InjectedValues[\.getCategoryListUseCaseProvider] = GetCategorieListUseCaseMock()
        let viewModel = MainViewModel()
        var receivedValues: [leboncoin.LBCItem] = []
        
        viewModel.$items
            .sink { result in
                receivedValues = result
                if result.count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchItems()
        
        wait(for: [expectation])
        XCTAssertEqual(receivedValues.count, 3)
    }
    
}
