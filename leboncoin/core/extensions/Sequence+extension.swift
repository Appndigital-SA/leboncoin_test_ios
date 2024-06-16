//
//  Sequence+extension.swift
//  leboncoin
//
//  Created by Didier Nizard on 14/06/2024.
//

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

extension [LBCItem] {
    mutating func sortedBy(_ sortType: SortType) -> [LBCItem] {
        switch sortType {
        case .dateAsc:
            return sorted(by: { $0.creationDate < $1.creationDate })
        case .dateDesc:
            return sorted(by: { $0.creationDate > $1.creationDate })
        case .priceAsc:
            return sorted(by: { $0.price < $1.price })
        case .priceDesc:
            return sorted(by: { $0.price > $1.price })
        }
    }
}
