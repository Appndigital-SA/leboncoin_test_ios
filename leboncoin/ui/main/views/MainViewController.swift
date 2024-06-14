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
        tableView.isHidden = true
        return tableView
    }()
    
    @UsesAutoLayout
    private var loader: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .orange
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    @UsesAutoLayout
    private var errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    @UsesAutoLayout
    private var reloadButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.clockwise.icloud"), for: .normal)
        button.tintColor = .orange
        button.isHidden = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
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
        
        self.title = "Le Bon Coin"
        
        updateUI()
        configureLayout()
        setUpBindings()
        
        viewModel.fetchItems()
    }
    
    private func updateUI() {
        view.backgroundColor = .white
        
        view.addSubviews(tableView, loader, errorLabel, reloadButton)
        
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
    }
    
    private func configureLayout() {
        tableView.stickToEdges(view: view)
        
        loader.centerInView(view: view)
        errorLabel.centerInView(view: view)
        
        reloadButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 12).isActive = true
        reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reloadButton.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
        reloadButton.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
    }
    
    private func setUpBindings() {
        reloadButton.addTarget(self, action: #selector(didTapReload), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.$items
            .sink { result in
                self.items = result
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$state
            .sink { state in
                switch state {
                case .loading:
                    self.loader.startAnimating()
                    self.tableView.isHidden = true
                    self.errorLabel.isHidden = true
                    self.reloadButton.isHidden = true
                case .finished:
                    self.loader.stopAnimating()
                    self.tableView.isHidden = false
                    self.errorLabel.isHidden = true
                    self.reloadButton.isHidden = true
                case .error(let message):
                    self.loader.stopAnimating()
                    self.tableView.isHidden = true
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = message
                    self.reloadButton.isHidden = false
                case .empty:
                    self.loader.stopAnimating()
                    self.tableView.isHidden = true
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Aucune offre disponible"
                    self.reloadButton.isHidden = false
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func didTapReload() {
        viewModel.fetchItems()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController(item: items[indexPath.row])
        self.navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
