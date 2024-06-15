//
//  RadioButton.swift
//  leboncoin
//
//  Created by Didier Nizard on 14/06/2024.
//

import UIKit

class RadioButton: UIView {
    
    @UsesAutoLayout
    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    @UsesAutoLayout
    private var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "radioButtonOff")
        return image
    }()
    
    var completion: (() -> ())? = nil
    
    init(text: String, isChecked: Bool){
        super.init(frame: .zero)
                
        label.text = text
        image.image = isChecked ? UIImage(named: "radioButtonOn") : UIImage(named: "radioButtonOff")
        
        addSubviews(label, image)
        configureView()
    }
    
    func onCompletion(completion: @escaping (() -> ())) {
        self.completion = completion
    }
    
    private func configureView() {
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        image.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        image.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tapRecognizer)
    }
    
    func setOn(isChecked: Bool) {
        image.image = isChecked ? UIImage(named: "radioButtonOn") : UIImage(named: "radioButtonOff")
    }
    
    @objc private func onTap() {
        completion?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
