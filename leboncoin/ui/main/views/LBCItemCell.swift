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
        lbl.numberOfLines = 2
       return lbl
    }()
    
    @UsesAutoLayout
    private var itemUrgent: UILabel = {
        let lbl = PaddingLabel(withInsets: 2.0, 2.0, 4.0, 4.0)
        lbl.textColor = .white
        lbl.backgroundColor = .red
        lbl.text = "URGENT"
       return lbl
    }()
    
    @UsesAutoLayout
    private var itemCatgeory: UILabel = {
        let lbl = PaddingLabel(withInsets: 2.0, 2.0, 4.0, 4.0)
        lbl.textColor = .white
       return lbl
    }()
    
    @UsesAutoLayout
    private var itemPrice: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
       return lbl
    }()
    
    init(item: LBCItem) {
        lbcItem = item
        
        super.init(style: .default, reuseIdentifier: "ItemCell")
        contentView.backgroundColor = .white
        accessoryType = .disclosureIndicator
        
        contentView.addSubviews(itemImage, itemTitle, itemCatgeory, itemUrgent, itemPrice)
        configureView()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        itemImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:10).isActive = true
        itemImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant:10).isActive = true
        itemImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:-10).isActive = true
        itemImage.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        itemTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        itemTitle.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant:10).isActive = true
        itemTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-10).isActive = true
        
        itemCatgeory.topAnchor.constraint(equalTo: itemImage.topAnchor).isActive = true
        itemCatgeory.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant:10).isActive = true
        
        itemUrgent.bottomAnchor.constraint(equalTo: itemImage.bottomAnchor).isActive = true
        itemUrgent.leadingAnchor.constraint(equalTo: itemImage.leadingAnchor).isActive = true
        
        itemPrice.bottomAnchor.constraint(equalTo: itemImage.bottomAnchor).isActive = true
        itemPrice.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor, constant:10).isActive = true
    }
    
    func updateUI() {
        if let imagesUrl = lbcItem.imagesUrl, let url = URL(string: imagesUrl.small) {
            itemImage.load(url: url)
        }
        
        itemTitle.text = lbcItem.title
        
        if let category = lbcItem.category {
            itemCatgeory.isHidden = false
            itemCatgeory.text = category.name
            itemCatgeory.backgroundColor = category.getColor()
        } else {
            itemCatgeory.isHidden = true
        }
        
        itemUrgent.isHidden = !lbcItem.isUrgent
        
        itemPrice.text = "Prix: \(lbcItem.price) €"
    }
}
