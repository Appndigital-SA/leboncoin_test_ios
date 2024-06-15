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
