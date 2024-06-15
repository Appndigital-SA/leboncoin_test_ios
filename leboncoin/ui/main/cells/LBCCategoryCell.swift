//
//  LBCCategoryCell.swift
//  leboncoin
//
//  Created by Didier Nizard on 14/06/2024.
//

import UIKit

class LBCCategoryCell: UICollectionViewCell {
    
    @UsesAutoLayout
    private var categoryTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 17.0)
       return lbl
    }()
    
    private var lbcCategory: LBCCategory!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.addSubviews(categoryTitle)
    }
    
    func setUp(category: LBCCategory, isSelected: Bool) {
        lbcCategory = category
        configureView()
        updateUI()
        
        if isSelected {
            categoryTitle.font = .boldSystemFont(ofSize: 17.0)
            categoryTitle.textColor = .accent
        } else {
            categoryTitle.font = .systemFont(ofSize: 17.0)
            categoryTitle.textColor = .black
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        categoryTitle.centerInView(view: contentView)
    }
    
    func updateUI() {
        categoryTitle.text = lbcCategory.name
    }
    
}
