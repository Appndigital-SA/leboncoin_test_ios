//
//  DetailViewController.swift
//  leboncoin
//
//  Created by Didier Nizard on 13/06/2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    @UsesAutoLayout
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    @UsesAutoLayout
    private var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    @UsesAutoLayout
    private var itemImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
       return img
    }()
    
    @UsesAutoLayout
    private var itemTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
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
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
       return lbl
    }()
    
    @UsesAutoLayout
    private var itemDescription: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.numberOfLines = 0
       return lbl
    }()
    
    @UsesAutoLayout
    private var itemPublishedDate: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.italicSystemFont(ofSize: 12)
        return lbl
    }()
    
    private let item: LBCItem
    
    init(item: LBCItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        self.title = item.title
        
        updateUI()
        configureLayout()
    }
    
    private func updateUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.accessibilityIdentifier = "detailItemViewIdentifier"
        
        if let imagesUrl = item.imagesUrl, let url = URL(string: imagesUrl.thumb) {
            contentView.addArrangedSubview(itemImage)
            itemImage.load(url: url)
        }
        
        if item.isUrgent {
            contentView.addArrangedSubview(itemUrgent)
        }
        
        contentView.addArrangedSubview(itemTitle)
        itemTitle.text = item.title
        
        if let category = item.category {
            contentView.addArrangedSubview(itemCatgeory)
            itemCatgeory.text = category.name
            itemCatgeory.backgroundColor = category.getColor()
        }
        
        contentView.addArrangedSubview(itemPrice)
        itemPrice.text = "Prix: \(item.price) €"
        
        contentView.addArrangedSubview(itemDescription)
        itemDescription.text = item.description
        
        contentView.addArrangedSubview(itemPublishedDate)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        itemPublishedDate.text = "Publié le \(formatter.string(from: item.creationDate))"
    }
    
    private func configureLayout() {
        scrollView.stickToEdges(view: view)
        
        contentView.stickToEdges(view: scrollView)
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        itemImage.widthAnchor.constraint(equalToConstant: 280.0).isActive = true
        itemImage.heightAnchor.constraint(equalToConstant: 280.0).isActive = true
    }
    
}
