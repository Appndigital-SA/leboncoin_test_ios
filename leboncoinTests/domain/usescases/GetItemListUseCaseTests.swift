//
//  GetItemListUseCaseTests.swift
//  leboncoinTests
//
//  Created by Didier Nizard on 14/06/2024.
//

import XCTest
import Combine
@testable import leboncoin

class GetItemListUseCaseTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    class SuccessItemRepositoryMock: ItemRepository {
        let mockItems = [
            LBCItem(id: 1, title: "Item 1", description: "Description 1", price: 1, imagesUrl: nil, category: LBCCategory(id: 1, name: "Véhicule"), creationDate: Date(), isUrgent: false),
            LBCItem(id: 2, title: "Item 2", description: "Description 2", price: 2, imagesUrl: nil, category: LBCCategory(id: 2, name: "Mode"), creationDate: Date(), isUrgent: true),
            LBCItem(id: 2, title: "Item 3", description: "Description 3", price: 3, imagesUrl: nil, category: LBCCategory(id: 3, name: "Bricolage"), creationDate: Date(), isUrgent: false),
        ]
        
        func fetchItemList() -> AnyPublisher<[leboncoin.LBCItem], any Error> {
            return Just(mockItems)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    class FailureItemRepositoryMock: ItemRepository {
        func fetchItemList() -> AnyPublisher<[leboncoin.LBCItem], any Error> {
            return Fail(error: ApiError.generalError("something went wrong"))
                .eraseToAnyPublisher()
        }
    }
    
    func testGetItemListUseCase_success() {
        let successRepository = SuccessItemRepositoryMock()
        
        let getItemListUseCase = GetItemListUseCaseImpl(itemRepository: successRepository)
        
        getItemListUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { items in
                XCTAssertEqual(items.count, 3)
                XCTAssertEqual(items.filter({ $0.isUrgent }).count, 1)
                XCTAssertEqual(items.filter({ !$0.isUrgent }).count, 2)
            }
            .store(in: &cancellables)

    }
    
    func testGetItemListUseCase_failure() {
        let failureRepository = FailureItemRepositoryMock()
        
        let getItemListUseCase = GetItemListUseCaseImpl(itemRepository: failureRepository)
        
        getItemListUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(let error):
                    if let apiError = error as? ApiError {
                        switch apiError {
                        case .generalError(let message):
                            XCTAssertEqual("something went wrong", message)
                        default:
                            XCTFail()
                        }
                    }
                }
            } receiveValue: { _ in
                XCTFail()
            }
            .store(in: &cancellables)

    }
    
}
