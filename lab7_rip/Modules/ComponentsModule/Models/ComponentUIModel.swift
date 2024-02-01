//
//  ComponentUIModel.swift
//  lab7_rip
//
//  Created by Mikhail on 15.12.2023.
//

import Foundation

struct ComponentUIModel {
    let uuid: String
    let name: String
    var imageUrl: String
    let worldName: String
    let amount: Int
    let properties: String

    init(uuid: String = "",
         name: String = "",
         imageUrl: String = "",
         worldName: String = "",
         amount: Int = 0,
         properties: String = "") {
        self.uuid = uuid
        self.name = name
        self.imageUrl = imageUrl
        self.worldName = worldName
        self.amount = amount
        self.properties = properties

        // Заменяем "localhost" на ваш ip
        if let range = imageUrl.range(of: "localhost") {
            self.imageUrl.replaceSubrange(range, with: ip)
        }
    }

    init(from component: ComponentResponseModel.Component) {
        self.init(uuid: component.uuid,
                  name: component.name,
                  imageUrl: component.imageUrl,
                  worldName: component.worldName,
                  amount: component.amount,
                  properties: component.properties)
    }
}
