//
//  AllMedicinesResponse.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import Foundation

struct ComponentItemModel {
    let uuid: String
    let name: String
    let imageUrl: String
    let worldName: String
    let amount: Int
    let properties: String
}

struct ComponentsListModel {
    let draftMedicine: String
    let components: [ComponentItemModel]
}

extension ComponentsListModel {
    init(componentsListResponseModel: ComponentsListResponseModel) {
        self.draftMedicine = componentsListResponseModel.draftMedicine ?? ""
        
        let componentItemModels = componentsListResponseModel.components.map { componentResponse in
            return ComponentItemModel(
                uuid: componentResponse.uuid,
                name: componentResponse.name,
                imageUrl: componentResponse.imageUrl,
                worldName: componentResponse.worldName,
                amount: componentResponse.amount,
                properties: componentResponse.properties
            )
        }
        
        self.components = componentItemModels
    }
}

