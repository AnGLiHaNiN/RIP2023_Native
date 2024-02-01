//
//  AllMedicinesResponse.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import Foundation

struct MedicineItemResponseModel: Codable, Hashable {
    let uuid: String
    let status: String
    let creationDate: String?
    let formationDate: String?
    let completionDate: String?
    let moderator: String?
    let customer: String
    let name: String?
    let verificationStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case uuid, status
        case creationDate = "creation_date"
        case formationDate = "formation_date"
        case completionDate = "completion_date"
        case moderator, customer, name
        case verificationStatus = "verification_status"
    }
}

struct MedicineListResponseModel: Codable {
    let medicines: [MedicineItemResponseModel]
}

struct OneMedecineAndConpnents: Codable {
    let medicine: MedicineItemResponseModel
    let components: [ComponentCountItemResponseModel]
}
