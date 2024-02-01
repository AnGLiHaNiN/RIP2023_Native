// 
//  MainComponentsBuilder.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import UIKit

enum ScreenType {
    case components
    case basket
    case medecine
}

final class MainComponentsBuilder {
    public static func build(type: ScreenType) -> MainComponentsViewController {
        let view = MainComponentsViewController(type: type)
        let router = MainComponentsRouter(view: view, navigationController: UINavigationController())
        let presenter = MainComponentsPresenter(view: view, router: router)
        
        view.presenter = presenter
        
        return view
    }
    
}
