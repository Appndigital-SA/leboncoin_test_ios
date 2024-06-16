//
//  GetCategorieListUseCaseTests.swift
//  leboncoinTests
//
//  Created by Didier Nizard on 16/06/2024.
//

import XCTest
import Combine
@testable import leboncoin

class GetCategorieListUseCaseTests: XCTestCase {
    
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
    
    func testGetCategorieListUseCase_success() {
        let expectation = expectation(description: "Wait for items")
        var error: Error?
        var items: [LBCCategory] = []
        
        InjectedValues[\.itemRepositoryProvider] = SuccessItemRepositoryMock()
        let getCategorieListUseCase = GetCategorieListUseCaseImpl()
        
        getCategorieListUseCase.execute()
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
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        XCTAssertEqual(items.count, 3)
    }
    
    func testGetCategorieListUseCase_failure() {
        let expectation = expectation(description: "Wait for items")
        var apiError: ApiError?
        
        InjectedValues[\.itemRepositoryProvider] = FailureItemRepositoryMock()
        let getCategorieListUseCase = GetCategorieListUseCaseImpl()
        
        getCategorieListUseCase.execute()
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
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNotNil(apiError)
    }
}

