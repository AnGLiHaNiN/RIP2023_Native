//
//  MedicineApiModel.swift
//  yourProjectName
//
//  Created by Mikhail on 04.12.2023.
//

import Foundation

struct MedicineApiModel: Codable {
    let medicines: [MedElement]

    struct MedElement: Codable {
        let name: String
        var imageUrl: String
        let dosage: String
        let amount: Int
        let manufacturer: String

        private enum CodingKeys: String, CodingKey {
            case name = "name"
            case imageUrl = "image_url"
            case dosage = "dosage"
            case amount = "amount"
            case manufacturer = "manufacturer"
        }
    }
}
