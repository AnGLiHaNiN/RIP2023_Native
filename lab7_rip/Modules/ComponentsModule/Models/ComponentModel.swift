//
//  ComponentModel.swift
//  yourProjectName
//
//  Created by Mikhail on 04.12.2023.
//

import Foundation

final class ComponentModel {
    private let catalogNetworkManager = ComponentService.shared
    
    func loadComponent(with title: String? = nil,
                     completion: @escaping (Result<[ComponentUIModel], Error>) -> Void) {
        catalogNetworkManager.getComponentData(with: title) { result in
            switch result {
            case .success(let data):

                let catalogUIModels = data.components.map { componentModel in
                    ComponentUIModel(uuid: componentModel.uuid,
                                     name: componentModel.name,
                                     imageUrl: componentModel.imageUrl,
                                     worldName: componentModel.worldName,
                                     amount: componentModel.amount,
                                     properties: componentModel.properties)
                }
                completion(.success(catalogUIModels))
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }
}
