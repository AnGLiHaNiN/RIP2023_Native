// 
//  MainComponentsPresenter.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import Foundation
import UIKit

protocol MainComponentsPresenterProtocol: AnyObject {
    init(view: MainComponentsViewControllerProtocol, router: MainComponentsRouterProtocol)
    func viewDidLoad()
    func updateName(_ name: String?)
    func wantToOpenDetails(with data: String)
    func wantToOpenBasket(with data: String)
    func createMed()
}

final class MainComponentsPresenter {
    
    private weak var view: MainComponentsViewControllerProtocol?
    private var router: MainComponentsRouterProtocol
    
    private var name: String? = ""
    private var medecineBasketID: String = ""

    init(view: MainComponentsViewControllerProtocol, router: MainComponentsRouterProtocol) {
        self.view = view
        self.router = router
    }

    private func showMainComponents() {
        
        switch view?.type {
        case .components:
            componentsCase()
        case .basket:
            basketCase()
        case .medecine:
            medecineCase()
        case .none:
            print("Ничего нет")
        }
    }
    
    private func componentsCase() {
        NetworkService.shared.getAllComponents(name: name) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(model):
                let model = ComponentsListModel(componentsListResponseModel: model)
                var items = [MainComponentsViewItem]()
                let group = DispatchGroup()
                
                medecineBasketID = model.draftMedicine
                
                for component in model.components {
                    var imageString = component.imageUrl.replacingOccurrences(of: "localhost", with: "172.20.10.13")
                    
                    group.enter()
                    if let url = URL(string: imageString) {
                        NetworkService.shared.loadImage(from: url) { imageNew in
                            DispatchQueue.main.async {
                                if let image = imageNew {
                                    let item = MainComponentsViewItem.componentItem(
                                        .init(
                                            uuid: component.uuid,
                                            title: component.name,
                                            subtitle: component.worldName,
                                            image: image
                                        )
                                    )
                                    items.append(item)
                                } else {
                                    print("Нет изображения для \(component.name)")
                                }
                                group.leave()
                            }
                        }
                    } else {
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self.view?.update(state: .data(items))
                }
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func medecineCase() {
        NetworkService.shared.getAllMedicines { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(model):
//                let model = ComponentsListModel(componentsListResponseModel: model)
                var items = [MainComponentsViewItem]()
                
                items = model.medicines.map {
                    MainComponentsViewItem.medecineItem($0)
                }
                
                
                self.view?.update(state: .data(items))
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func basketCase() {
        
        NetworkService.shared.getOneMedicine(medicineID: view?.medicineId ?? "") { [weak self] result in
            guard let self else { return }
            
            switch result {
            case let .success(model):
                var items = [MainComponentsViewItem]()
                let group = DispatchGroup()
                
                for component in model.components {
                    var imageString = component.imageUrl.replacingOccurrences(of: "localhost", with: "172.20.10.13")
                    
                    group.enter()
                    if let url = URL(string: imageString) {
                        NetworkService.shared.loadImage(from: url) { imageNew in
                            DispatchQueue.main.async {
                                if let image = imageNew {
                                    let item = MainComponentsViewItem.basketItem(
                                        .init(
                                            uuid: component.uuid,
                                            title: component.name,
                                            subtitle: component.worldName,
                                            image: image,
                                            count: component.count ?? 0
                                        )
                                    )
                                    items.append(item)
                                } else {
                                    print("Нет изображения для \(component.name)")
                                }
                                group.leave()
                            }
                        }
                    } else {
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self.view?.update(state: .data(items))
                }
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func createMed2() {
        NetworkService.shared.userConfirm { result in
            print("")
        }
    }
}

extension MainComponentsPresenter : MainComponentsPresenterProtocol {
    func createMed() {
        createMed2()
        
    }
    
    func wantToOpenBasket(with data: String) {
        router.openBasketScreen(with: medecineBasketID)
    }
    
    func wantToOpenDetails(with data: String) {
        router.openDetailsScreen(with: data)
    }
    
    func updateName(_ name: String?) {
        self.name = name?.folding(options: .diacriticInsensitive, locale: Locale(identifier: "en"))
    }
    
    func viewDidLoad() {
        showMainComponents()
    }
}
