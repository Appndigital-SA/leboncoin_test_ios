//
//  LBCImagesUrlDto.swift
//  leboncoin
//
//  Created by Didier Nizard on 12/06/2024.
//

struct LBCImagesUrlDto: Decodable {
    let small: String?
    let thumb: String?
}

extension LBCImagesUrlDto {
    func toModel() -> LBCImagesUrl? {
        if let small, let thumb {
            return LBCImagesUrl(small: small, thumb: thumb)
        }
        
        return nil
    }
}
