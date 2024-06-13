//
//  LBCItemDto.swift
//  leboncoin
//
//  Created by Didier Nizard on 12/06/2024.
//

import Foundation

struct LBCItemDto: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case title
        case description
        case price
        case imagesUrl = "images_url"
        case creationDate = "creation_date"
        case isUrgent = "is_urgent"
    }
    
    let id: Int
    let categoryId: Int
    let title: String
    let description: String
    let price: Int
    let imagesUrl: LBCImagesUrlDto
    let creationDate: String
    let isUrgent: Bool
}

extension LBCItemDto{
    func toModel(category: LBCCategory?) -> LBCItem {
        return LBCItem(
            id: id,
            title: title,
            description: description,
            price: price,
            imagesUrl: imagesUrl.toModel(),
            category: category,
            creationDate: dateFormatter.date(from: creationDate) ?? Date(),
            isUrgent: isUrgent
        )
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'+000'"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
