//
//  ComponentResponseModel.swift
//  yourProjectName
//
//  Created by Mikhail on 04.12.2023.
//

import Foundation

struct ComponentResponseModel: Codable {
    let components: [Component]

    struct Component: Codable {
        let uuid: String
        let name: String
        let imageUrl: String
        let worldName: String
        let amount: Int
        let properties: String

        private enum CodingKeys: String, CodingKey {
            case uuid
            case name
            case imageUrl = "image_url"
            case worldName = "world_name"
            case amount
            case properties
        }
    }
}

