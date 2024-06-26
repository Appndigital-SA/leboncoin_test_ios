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
        func fetchCategoriesList() -> AnyPublisher<[leboncoin.LBCCategory], any Error> {
            return Just(MockEntities.mockCategories)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        func fetchItemsList(configuration: leboncoin.LBCConfiguration) -> AnyPublisher<[leboncoin.LBCItem], any Error> {
            return Just(MockEntities.mockItems)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    class FailureItemRepositoryMock: ItemRepository {
        func fetchCategoriesList() -> AnyPublisher<[leboncoin.LBCCategory], any Error> {
            return Fail(error: ApiError.generalError("something went wrong"))
                .eraseToAnyPublisher()
        }
        
        func fetchItemsList(configuration: leboncoin.LBCConfiguration) -> AnyPublisher<[leboncoin.LBCItem], any Error> {
            return Fail(error: ApiError.generalError("something went wrong"))
                .eraseToAnyPublisher()
        }
    }
    
    func testGetItemListUseCase_success() {
        let expectation = expectation(description: "Wait for items")
        var error: Error?
        var items: [LBCItem] = []
        
        InjectedValues[\.itemRepositoryProvider] = SuccessItemRepositoryMock()
        let getItemListUseCase = GetItemListUseCaseImpl()
        
        getItemListUseCase.execute(configuration: LBCConfiguration())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                
                expectation.fulfill()
            } receiveValue: { result in
                items = result
            }
            .store(in: &cancellables)
        
        // Awaiting fulfilment of our expecation before
        // performing our asserts:
        waitForExpectations(timeout: 10)

        // Asserting that our Combine pipeline yielded the
        // correct output:
        XCTAssertNil(error)
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(items.filter({ $0.isUrgent }).count, 1)
        XCTAssertEqual(items.filter({ !$0.isUrgent }).count, 2)
    }
    
    func testGetItemListUseCase_failure() {
        let expectation = expectation(description: "Wait for items")
        var apiError: ApiError?
        
        InjectedValues[\.itemRepositoryProvider] = FailureItemRepositoryMock()
        let getItemListUseCase = GetItemListUseCaseImpl()
        
        getItemListUseCase.execute(configuration: LBCConfiguration())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    apiError = error as? ApiError
                }
                
                expectation.fulfill()
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
        
        // Awaiting fulfilment of our expecation before
        // performing our asserts:
        waitForExpectations(timeout: 10)
        
        // Asserting that our Combine pipeline yielded the
        // correct output:
        XCTAssertNotNil(apiError)
    }
}
