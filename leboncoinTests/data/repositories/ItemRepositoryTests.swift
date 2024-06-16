//
//  ItemRepositoryTests.swift
//  leboncoinTests
//
//  Created by Didier Nizard on 16/06/2024.
//

import XCTest
import Combine
@testable import leboncoin

class ItemRepositoryTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    static let mockItemsDto = [
        LBCItemDto(id: 1, categoryId: 1, title: "Item 1", description: "Description 1", price: 1, imagesUrl: LBCImagesUrlDto(small: nil, thumb: nil), creationDate: "2019-11-05T15:56:59+0000", isUrgent: false),
        LBCItemDto(id: 2, categoryId: 2, title: "Item 2", description: "Description 2", price: 2, imagesUrl: LBCImagesUrlDto(small: nil, thumb: nil), creationDate: "2019-11-05T15:56:59+0000", isUrgent: true),
        LBCItemDto(id: 3, categoryId: 3, title: "Item 1", description: "Description 3", price: 3, imagesUrl: LBCImagesUrlDto(small: nil, thumb: nil), creationDate: "2019-11-05T15:56:59+0000", isUrgent: false),
    ]
    
    static let mockCategoriesDto = [
        LBCCategoryDto(id: 1, name: "Véhicule"),
        LBCCategoryDto(id: 2, name: "Mode"),
        LBCCategoryDto(id: 3, name: "Bricolage"),
    ]
    
    class SuccessApiServiceMock: ApiService {
        func fetchItems() -> AnyPublisher<[leboncoin.LBCItemDto], any Error> {
            return Just(ItemRepositoryTests.mockItemsDto)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        func fetchCategories() -> AnyPublisher<[leboncoin.LBCCategoryDto], any Error> {
            return Just(ItemRepositoryTests.mockCategoriesDto)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    class FailureApiServiceMock: ApiService {
        func fetchItems() -> AnyPublisher<[leboncoin.LBCItemDto], any Error> {
            return Fail(error: ApiError.generalError("something went wrong"))
                .eraseToAnyPublisher()
        }
        
        func fetchCategories() -> AnyPublisher<[leboncoin.LBCCategoryDto], any Error> {
            return Fail(error: ApiError.generalError("something went wrong"))
                .eraseToAnyPublisher()
        }
    }
    
    func testItemRepositoryFetchItems_success() {
        let expectation = expectation(description: "Wait for items")
        var error: Error?
        var items: [LBCItem] = []
        
        InjectedValues[\.apiServiceProvider] = SuccessApiServiceMock()
        let itemRepository = ItemRepositoryImpl()
        
        itemRepository.fetchCategoriesList()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
            } receiveValue: {_ in 
                itemRepository.fetchItemsList(configuration: LBCConfiguration())
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
                    .store(in: &self.cancellables)
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
    
    func testItemRepositoryFetchItems_onlyUrgent_success() {
        let expectation = expectation(description: "Wait for items")
        var error: Error?
        var items: [LBCItem] = []
        
        InjectedValues[\.apiServiceProvider] = SuccessApiServiceMock()
        let itemRepository = ItemRepositoryImpl()
        
        itemRepository.fetchCategoriesList()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
            } receiveValue: {_ in
                itemRepository.fetchItemsList(configuration: LBCConfiguration(onlyUrgent: true))
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
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
        
        // Awaiting fulfilment of our expecation before
        // performing our asserts:
        waitForExpectations(timeout: 10)

        // Asserting that our Combine pipeline yielded the
        // correct output:
        XCTAssertNil(error)
        XCTAssertEqual(items.count, 1)
    }
    
    func testItemRepositoryFetchItems_filterCategory_success() {
        let expectation = expectation(description: "Wait for items")
        var error: Error?
        var items: [LBCItem] = []
        
        InjectedValues[\.apiServiceProvider] = SuccessApiServiceMock()
        let itemRepository = ItemRepositoryImpl()
        
        itemRepository.fetchCategoriesList()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
            } receiveValue: {_ in
                itemRepository.fetchItemsList(configuration: LBCConfiguration(selectedCategory: 2))
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
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
        
        // Awaiting fulfilment of our expecation before
        // performing our asserts:
        waitForExpectations(timeout: 10)

        // Asserting that our Combine pipeline yielded the
        // correct output:
        XCTAssertNil(error)
        XCTAssertEqual(items.count, 1)
    }
    
    func testItemRepositoryFetchItems_sortResult_success() {
        let expectation = expectation(description: "Wait for items")
        var error: Error?
        var items: [LBCItem] = []
        
        InjectedValues[\.apiServiceProvider] = SuccessApiServiceMock()
        let itemRepository = ItemRepositoryImpl()
        
        itemRepository.fetchCategoriesList()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
            } receiveValue: {_ in
                itemRepository.fetchItemsList(configuration: LBCConfiguration(sortType: .priceDesc))
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
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
        
        // Awaiting fulfilment of our expecation before
        // performing our asserts:
        waitForExpectations(timeout: 10)

        // Asserting that our Combine pipeline yielded the
        // correct output:
        XCTAssertNil(error)
        XCTAssertEqual(items.count, 3)
        XCTAssertGreaterThan(items.first!.price, items.last!.price)
    }
    
    func testItemRepositoryFetchItems_failure() {
        let expectation = expectation(description: "Wait for items")
        var apiError: ApiError?
        
        InjectedValues[\.apiServiceProvider] = FailureApiServiceMock()
        let itemRepository = ItemRepositoryImpl()
        
        itemRepository.fetchItemsList(configuration: LBCConfiguration())
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
