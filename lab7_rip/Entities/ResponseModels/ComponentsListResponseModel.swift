//
//  AllMedicinesResponse.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import Foundation

struct ComponentItemResponseModel: Codable {
    let uuid: String
    let name: String
    let imageUrl: String
    let worldName: String
    let amount: Int
    let properties: String

    enum CodingKeys: String, CodingKey {
        case uuid, name
        case imageUrl = "image_url"
        case worldName = "world_name"
        case amount, properties
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(String.self, forKey: .uuid)
        name = try container.decode(String.self, forKey: .name)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        worldName = try container.decode(String.self, forKey: .worldName)
        amount = try container.decode(Int.self, forKey: .amount)
        properties = try container.decode(String.self, forKey: .properties)
    }
}


struct ComponentsListResponseModel: Codable {
    let draftMedicine: String?
    let components: [ComponentItemResponseModel]
    
    enum CodingKeys: String, CodingKey {
        case draftMedicine = "draft_medicine"
        case components
    }
}


struct ComponentCountItemResponseModel: Codable {
    let uuid: String
    let name: String
    let imageUrl: String
    let worldName: String
    let amount: Int
    let properties: String
    let count: Int?

    enum CodingKeys: String, CodingKey {
        case uuid, name
        case imageUrl = "image_url"
        case worldName = "world_name"
        case amount, properties, count
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(String.self, forKey: .uuid)
        name = try container.decode(String.self, forKey: .name)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        worldName = try container.decode(String.self, forKey: .worldName)
        amount = try container.decode(Int.self, forKey: .amount)
        properties = try container.decode(String.self, forKey: .properties)
        count = try container.decode(Int.self, forKey: .count)
    }
}


struct ComponentsCountListResponseModel: Codable {
    let draftMedicine: String?
    let components: [ComponentItemResponseModel]
    
    enum CodingKeys: String, CodingKey {
        case draftMedicine = "draft_medicine"
        case components
    }
}
