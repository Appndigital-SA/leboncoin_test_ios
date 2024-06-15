//
//  SwitchLabel.swift
//  leboncoin
//
//  Created by Didier Nizard on 14/06/2024.
//

import UIKit

class SwitchLabel: UIView {
    
    @UsesAutoLayout
    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    @UsesAutoLayout
    private var switchButton: UISwitch = {
        let button = UISwitch()
        return button
    }()
    
    var completion: ((Bool) -> ())? = nil
    
    init(text: String, isChecked: Bool){
        super.init(frame: .zero)
                
        label.text = text
        switchButton.isOn = isChecked
        
        addSubviews(label, switchButton)
        configureView()
    }
    
    func onCompletion(completion: @escaping ((Bool) -> ())) {
        self.completion = completion
    }
    
    private func configureView() {
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        
        switchButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        
        switchButton.addTarget(self, action: #selector(onTap), for: .valueChanged)
    }
    
    func setOn(isChecked: Bool) {
        switchButton.isOn = isChecked
    }
    
    @objc private func onTap() {
        completion?(switchButton.isOn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

