//
//  MockEntities.swift
//  leboncoinTests
//
//  Created by Didier Nizard on 16/06/2024.
//

import XCTest
@testable import leboncoin

class MockEntities {
    static let mockItems = [
        LBCItem(id: 1, title: "Item 1", description: "Description 1", price: 1, imagesUrl: nil, category: LBCCategory(id: 1, name: "Véhicule"), creationDate: Date(), isUrgent: false),
        LBCItem(id: 2, title: "Item 2", description: "Description 2", price: 2, imagesUrl: nil, category: LBCCategory(id: 2, name: "Mode"), creationDate: Date(), isUrgent: true),
        LBCItem(id: 2, title: "Item 3", description: "Description 3", price: 3, imagesUrl: nil, category: LBCCategory(id: 3, name: "Bricolage"), creationDate: Date(), isUrgent: false),
    ]
    
    static let mockCategories = [
        LBCCategory(id: 1, name: "Véhicule"),
        LBCCategory(id: 2, name: "Mode"),
        LBCCategory(id: 3, name: "Bricolage"),
    ]
}
