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
    
    private var viewModel: MainViewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private var items: [LBCItem] = []
    
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
        
        tableView.separatorStyle = .none
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
}

extension MainViewController: UITableViewDelegate {
    
}
