// 
//  MainComponentsRouter.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import UIKit

protocol MainComponentsRouterProtocol {
//    init(view: MainComponentsViewController)
    func openDetailsScreen(with data: String)
    func openBasketScreen(with data: String)
}

final class MainComponentsRouter {
    
    private weak var view: MainComponentsViewController?
    private var navigationController: UINavigationController?
    
    init(view: MainComponentsViewController, navigationController: UINavigationController) {
        self.view = view
        self.navigationController = navigationController
    }
}

extension MainComponentsRouter: MainComponentsRouterProtocol {
    func openBasketScreen(with data: String) {
        let newController = MainComponentsBuilder.build(type: .basket)
        newController.medicineId = data
        view?.present(UINavigationController(rootViewController: newController), animated: true)
    }
    

    func openDetailsScreen(with data: String) {
        let destinationViewController = DetailInformationViewController2(uuid: data)

        view?.navigationController?.pushViewController(destinationViewController, animated: true)
    }
}
