//
//  MainViewController.swift
//  leboncoin
//
//  Created by Didier Nizard on 11/06/2024.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    @UsesAutoLayout
    private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var items: [LBCItem] = []
    
    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        updateUI()
        configureLayout()
        setUpBindings()
        
        viewModel.fetchItems()
    }
    
    private func updateUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
    }
    
    private func configureLayout() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setUpBindings() {
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.$items
            .sink { result in
                self.items = result
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return LBCItemCell(item: items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension MainViewController: UITableViewDelegate {
    
}
