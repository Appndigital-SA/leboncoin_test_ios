//
//  LBCItemCell.swift
//  leboncoin
//
//  Created by Didier Nizard on 12/06/2024.
//

import UIKit

class LBCItemCell: UITableViewCell {
    
    private let lbcItem: LBCItem
    
    @UsesAutoLayout
    private var itemImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
       return img
    }()
    
    @UsesAutoLayout
    private var itemTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
       return lbl
    }()
    
    init(item: LBCItem) {
        lbcItem = item
        
        super.init(style: .default, reuseIdentifier: "ItemCell")
        contentView.backgroundColor = .white
        
        contentView.addSubview(itemImage)
        contentView.addSubview(itemTitle)
        configureView()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        itemImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        itemImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:10).isActive = true
        itemImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        itemImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        itemTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        itemTitle.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant:10).isActive = true
    }
    
    func updateUI() {
        if let imagesUrl = lbcItem.imagesUrl, let url = URL(string: imagesUrl.thumb) {
            itemImage.load(url: url)
        }
        
        itemTitle.text = lbcItem.title
    }
}
