// 
//  MainComponentsViewController.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import UIKit
import SnapKit

protocol MainComponentsViewControllerProtocol: AnyObject {
    var type: ScreenType { get }
    var medicineId: String? { get }
    func update(state: MainComponentsViewState)
}

final class MainComponentsViewController: UIViewController {
    
    let type: ScreenType
    var medicineId: String?
    
    init(type: ScreenType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, MainComponentsViewItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, MainComponentsViewItem>

    public var presenter: MainComponentsPresenterProtocol!
    private lazy var dataSource = makeDataSource()
    
    private lazy var collectionView = UICollectionView(
        frame: view.frame,
        collectionViewLayout: .listCollectionViewLayout(estimatedHeight: 144)
    )
    let refreshControl = UIRefreshControl()
    
    
    
    override public func viewDidLoad() -> () {
        super.viewDidLoad()
        setupView()
        setupNavbar()
        setupCollectionView()
        presenter.viewDidLoad()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        
        refreshControl.addTarget(self, action: #selector(refreshButtonTapped), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        presenter.viewDidLoad()
    }
    
    private func setupNavbar() {
        var rightBarButtonItem: UIBarButtonItem!
        var leftBarButtonItem: UIBarButtonItem!
        
        switch type {
        case .components:
            rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                     style: .done,
                                                     target: self,
                                                     action: #selector(findButtonTapped))
            
            if let token = APIService.getToken() {
                leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "basket"),
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(basketButtonTapped))
            } else {
                leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ""),
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(basketButtonTapped))
            }
            
        case .basket:
            rightBarButtonItem = UIBarButtonItem(title: "Создать заявку",
                                                     style: .done,
                                                     target: self,
                                                     action: #selector(createMedButtonTapped))
            
            leftBarButtonItem = UIBarButtonItem(title: "Закртыть",
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(closeButtonTapped))
        case .medecine:
            rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                     style: .done,
                                                     target: self,
                                                     action: #selector(findButtonTapped))
            
            leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"),
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(reloaddButtonTapped))
        }
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    private func setupCollectionView() {
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = .clear
            collectionView.contentInset.bottom = 20

//            collectionView.registerCell(ComponentCell.self)
        collectionView.register(ComponentCell.self, forCellWithReuseIdentifier: "ComponentCell")
        collectionView.register(MedicineItemCollectionViewCell.self, forCellWithReuseIdentifier: "MedicineItemCollectionViewCell")
        collectionView.register(BasketCell.self, forCellWithReuseIdentifier: "BasketCell")
        }

        private func makeDataSource() -> DataSource {
            DataSource(collectionView: collectionView) { collectionView, indexPath, item in
                switch item {
                case let .componentItem(displayData):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComponentCell", for: indexPath) as? ComponentCell else {
                        fatalError("Cannot create a cell")
                    }
                    cell.configure(with: displayData)
                    return cell
                case let .medecineItem(displayData):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MedicineItemCollectionViewCell", for: indexPath) as? MedicineItemCollectionViewCell else {
                        fatalError("Cannot create a cell")
                    }
                    cell.configure(with: displayData)
                    return cell
                case let .basketItem(displayData):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasketCell", for: indexPath) as? BasketCell else {
                        fatalError("Cannot create a cell")
                    }
                    cell.configure(with: displayData)
                    return cell
                }
            }
        }
}

//MARK:- NavBar Actions

extension MainComponentsViewController {
    @objc private func createMedButtonTapped() {
        presenter.createMed()
        presenter.updateName(nil)
        self.dismiss(animated: true)
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func reloaddButtonTapped() {
        presenter.updateName(nil)
        presenter.viewDidLoad()
    }
    
    @objc private func refreshButtonTapped() {
        presenter.updateName(nil)
        presenter.viewDidLoad()
        refreshControl.endRefreshing()
    }
    
    @objc private func basketButtonTapped() {
        presenter.wantToOpenBasket(with: "Пошла")
    }
    
    @objc private func findButtonTapped() {
        // Показать окно поиска (например, модальный контроллер или другой способ)
        
        // Пример модального контроллера для ввода параметра поиска
        let searchAlert = UIAlertController(title: "Поиск", message: "Введите параметр поиска", preferredStyle: .alert)
        searchAlert.addTextField { textField in
            textField.placeholder = "Параметр поиска"
        }
        let searchAction = UIAlertAction(title: "Поиск", style: .default) { [weak self] _ in
            if let searchText = searchAlert.textFields?.first?.text {
                self?.handleSearch(searchText)
            }
        }
        searchAlert.addAction(searchAction)
        present(searchAlert, animated: true, completion: nil)
    }
    
    private func handleSearch(_ searchText: String) {
        presenter.updateName(searchText)
        presenter.viewDidLoad()
    }
    
    @objc private func searchTextFieldEditingDidEndOnExit(_ sender: UITextField) {
        if let searchText = sender.text {
            handleSearch(searchText)
        }
    }
}


extension MainComponentsViewController: MainComponentsViewControllerProtocol {
    func update(state: MainComponentsViewState) {
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        
        switch state {
        case let .data(items):
            snapshot.appendItems(items, toSection: 0)
            collectionView.isScrollEnabled = true
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


extension MainComponentsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            switch item {
            case .componentItem(let displayData):
                presenter.wantToOpenDetails(with: displayData.uuid)
                
            case .medecineItem(let displayData):
                print(displayData.name ?? "")
            case .basketItem(let displayData):
                print("")
            }
        }
    }
}
