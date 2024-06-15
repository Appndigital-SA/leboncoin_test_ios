//
//  SettingsViewController.swift
//  leboncoin
//
//  Created by Didier Nizard on 14/06/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
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
        stackView.layoutMargins = UIEdgeInsets(top: 32, left: 16, bottom: 0, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    @UsesAutoLayout
    private var sortDateDesc: RadioButton = {
        let radioButton = RadioButton(text: "Du plus récent au plus ancien", isChecked: true)
        return radioButton
    }()
    
    @UsesAutoLayout
    private var sortDateAsc: RadioButton = {
        let radioButton = RadioButton(text: "Du plus ancien au plus récent", isChecked: false)
        return radioButton
    }()
    
    @UsesAutoLayout
    private var sortPriceDesc: RadioButton = {
        let radioButton = RadioButton(text: "Du plus cher au moins cher", isChecked: false)
        return radioButton
    }()
    
    @UsesAutoLayout
    private var sortPriceAsc: RadioButton = {
        let radioButton = RadioButton(text: "Du moins cher au plus cher", isChecked: false)
        return radioButton
    }()
    
    @UsesAutoLayout
    private var switchUrgent: SwitchLabel = {
        let button = SwitchLabel(text: "Uniquement les plus urgents", isChecked: false)
        return button
    }()
    
    @UsesAutoLayout
    private var validateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .accent
        button.tintColor = .white
        button.setTitle("Valider", for: .normal)
        return button
    }()
    
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        configureLayout()
        setUpBindings()
    }
    
    private func updateUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addArrangedSubview(sortDateDesc)
        contentView.addArrangedSubview(sortDateAsc)
        contentView.addArrangedSubview(sortPriceAsc)
        contentView.addArrangedSubview(sortPriceDesc)
        contentView.addArrangedSubview(switchUrgent)
        contentView.addArrangedSubview(validateButton)
    }
    
    private func configureLayout() {
        scrollView.stickToEdges(view: view)
        
        contentView.stickToEdges(view: scrollView)
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        [sortDateDesc, sortDateAsc, sortPriceAsc, sortPriceDesc, switchUrgent].forEach {
            $0.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            $0.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        }
        
        switchUrgent.onCompletion { [self] value in
            viewModel.sortOnlyUrgent(isChecked: value)
        }
        
        sortDateAsc.onCompletion {
            self.viewModel.sortBy(.dateAsc)
            self.refeshRadio()
        }
        sortDateDesc.onCompletion {
            self.viewModel.sortBy(.dateDesc)
            self.refeshRadio()
        }
        sortPriceAsc.onCompletion {
            self.viewModel.sortBy(.priceAsc)
            self.refeshRadio()
        }
        sortPriceDesc.onCompletion {
            self.viewModel.sortBy(.priceDesc)
            self.refeshRadio()
        }
        
        validateButton.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
    }
    
    private func setUpBindings() {
        refeshRadio()
        
        switchUrgent.setOn(isChecked: viewModel.configuration.onlyUrgent)
        
        validateButton.addTarget(self, action: #selector(didTapValidate), for: .touchUpInside)
    }
    
    private func refeshRadio() {
        sortDateAsc.setOn(isChecked: viewModel.configuration.sortType == .dateAsc)
        sortDateDesc.setOn(isChecked: viewModel.configuration.sortType == .dateDesc)
        sortPriceAsc.setOn(isChecked: viewModel.configuration.sortType == .priceAsc)
        sortPriceDesc.setOn(isChecked: viewModel.configuration.sortType == .priceDesc)
    }
    
    @objc private func didTapValidate() {
        self.dismiss(animated: true)
    }
}
