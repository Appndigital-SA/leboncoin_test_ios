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
    private var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    @UsesAutoLayout
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.isHidden = true
        return collectionView
    }()
    
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
    private var categories: [LBCCategory] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        rightButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        rightButton.isHidden = true
    }
    
    private func updateUI() {
        navigationController?.navigationBar.addSubview(rightButton)
        
        view.backgroundColor = .white
        
        view.addSubviews(collectionView, tableView, loader, errorLabel, reloadButton)
        
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
    }
    
    private func configureLayout() {
        if let navigationBar = navigationController?.navigationBar {
            rightButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -10.0).isActive = true
            rightButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -10.0).isActive = true
            rightButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            rightButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        }
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true

        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        loader.centerInView(view: view)
        errorLabel.centerInView(view: view)
        
        reloadButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 12).isActive = true
        reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reloadButton.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
        reloadButton.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
    }
    
    private func setUpBindings() {
        rightButton.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
        reloadButton.addTarget(self, action: #selector(didTapReload), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LBCItemCell.self, forCellReuseIdentifier: "itemCell")
        
        viewModel.$items
            .sink { result in
                self.items = result
                self.tableView.reloadData()
                // To update selected category
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LBCCategoryCell.self, forCellWithReuseIdentifier: "categoryCell")
        
        viewModel.$categories
            .sink { result in
                self.categories = result
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$state
            .sink { state in
                switch state {
                case .loading:
                    self.loader.startAnimating()
                    self.tableView.isHidden = true
                    self.collectionView.isHidden = true
                    self.errorLabel.isHidden = true
                    self.reloadButton.isHidden = true
                case .finished:
                    self.loader.stopAnimating()
                    self.tableView.isHidden = false
                    self.collectionView.isHidden = false
                    self.errorLabel.isHidden = true
                    self.reloadButton.isHidden = true
                case .error(let message):
                    self.loader.stopAnimating()
                    self.tableView.isHidden = true
                    self.collectionView.isHidden = true
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = message
                    self.reloadButton.isHidden = false
                case .empty:
                    self.loader.stopAnimating()
                    self.tableView.isHidden = true
                    self.collectionView.isHidden = true
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
    
    @objc private func didTapSettings() {
        let settingsVC = SettingsViewController(viewModel: viewModel)
        navigationController?.present(settingsVC, animated: true)
    }
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! LBCItemCell
        cell.setUp(item: items[indexPath.row])
        return cell
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

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! LBCCategoryCell
        
        let currentCategory = categories[indexPath.row]
        cell.setUp(category: currentCategory, isSelected: currentCategory.id == viewModel.configuration.selectedCategory)
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.filterBy(categories[indexPath.row])
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font: UIFont = UIFont.systemFont(ofSize: 17.0)
        let width = categories[indexPath.row].name.size(withAttributes: [NSAttributedString.Key.font: font]).width
        return CGSize(width: width + 20.0 , height: 50.0)
    }
}
