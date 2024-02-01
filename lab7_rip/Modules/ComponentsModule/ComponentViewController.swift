//
//  ComponentViewController.swift
//  yourProjectName
//
//  Created by Mikhail on 16.10.2023.
//

import UIKit

class ComponentViewController: UIViewController {

    private let imageManager = ImageManager.shared
    private let model = ComponentModel()
    private var categoryModel: [ComponentUIModel] = []
    private lazy var catalogTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ComponentTableViewCell.self, forCellReuseIdentifier: "ComponentCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Список веществ"
        view.backgroundColor = .systemGray3
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                                style: .done,
                                                target: self,
                                                action: #selector(findButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"),
                                                style: .done,
                                                target: self,
                                                action: #selector(reloaddButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem

        view.addSubview(catalogTableView)
        setupComponentTableView()
        loadComponent()
    }
    
    @objc
    private func findButtonTapped() {
        // Создаем UIAlertController
        let alertController = UIAlertController(title: "Поиск",
                                                message: nil,
                                                preferredStyle: .alert)

        // Добавляем текстовое поле для типа
        alertController.addTextField { textField in
            textField.placeholder = "Введите название"
        }

        // Добавляем кнопку Найти
        let findAction = UIAlertAction(title: "Найти", style: .default) { [weak self] _ in
            // код по обработке введенных данных
            if let searchText = alertController.textFields?.first?.text,
               let priceText = alertController.textFields?.last?.text {
                self?.handleSearch(searchText)
            }
        }

        alertController.addAction(findAction)

        // Добавляем кнопку Отмена
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        // Показываем UIAlertController
        present(alertController, animated: true, completion: nil)
    }

    private func handleSearch(_ type: String?) {

        // Your existing code to load data based on type and price
        model.loadComponent(with: type) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.categoryModel = data
                    self?.catalogTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    
    @objc
    private func reloaddButtonTapped() {
        loadComponent()
    }
    
    // задаем отступы (в данном слечае прибито к краям экрана)
    private func setupComponentTableView() {
        catalogTableView.translatesAutoresizingMaskIntoConstraints = false
        catalogTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        catalogTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        catalogTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        catalogTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    private func loadComponent() {
        model.loadComponent { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    print(data)
                    self?.categoryModel = data
                    self?.catalogTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ComponentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // колечество ячеек в таблице
        categoryModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // создание ячеек
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "ComponentCell", for: indexPath) as? ComponentTableViewCell else {
            return .init()
        }
        cell.cellConfigure(with: categoryModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { // меняет размер ячейки
        250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedModel = categoryModel[indexPath.row]

        let detailVC = DetailInformationViewController()

        detailVC.datailConfigure(with: selectedModel)

        navigationController?.pushViewController(detailVC, animated: true)
    }

}
