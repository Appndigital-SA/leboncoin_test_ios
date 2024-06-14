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
        let mockItems = [
            LBCItem(id: 1, title: "Item 1", description: "Description 1", price: 1, imagesUrl: nil, category: LBCCategory(id: 1, name: "Véhicule"), creationDate: Date(), isUrgent: false),
            LBCItem(id: 2, title: "Item 2", description: "Description 2", price: 2, imagesUrl: nil, category: LBCCategory(id: 2, name: "Mode"), creationDate: Date(), isUrgent: true),
            LBCItem(id: 2, title: "Item 3", description: "Description 3", price: 3, imagesUrl: nil, category: LBCCategory(id: 3, name: "Bricolage"), creationDate: Date(), isUrgent: false),
        ]
        
        func execute() -> AnyPublisher<[leboncoin.LBCItem], any Error> {
            return Just(mockItems)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func test_whenUseCaseRetrievesItems_thenViewModelContainsSame() {
        let expectation = expectation(description: "Wait for items")
        
        let getItemListUseCaseMock = GetItemListUseCaseMock()
        let viewModel = MainViewModel(useCase: getItemListUseCaseMock)
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
