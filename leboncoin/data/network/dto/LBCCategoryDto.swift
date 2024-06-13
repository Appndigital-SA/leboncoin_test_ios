//
//  LBCCategoryDto.swift
//  leboncoin
//
//  Created by Didier Nizard on 13/06/2024.
//

struct LBCCategoryDto: Decodable {
    let id: Int
    let name: String
}

extension LBCCategoryDto {
    func toModel() -> LBCCategory {
        return LBCCategory(id: id, name: name)
    }
}

