//
//  MedicineUIModel.swift
//  lab7_rip
//
//  Created by Mikhail on 15.12.2023.
//

import Foundation

struct MedicineUIModel {
    let name: String
    var imageUrl: String
    let dosage: String
    let amount: Int
    let manufacturer: String
    
    init(name: String = "",
         imageUrl: String = "",
         dosage: String = "",
         amount: Int = 0,
         manufacturer: String = "") {
        self.name = name
        self.imageUrl = imageUrl
        self.dosage = dosage
        self.amount = amount
        self.manufacturer = manufacturer
        
        if let range = imageUrl.range(of: "localhost") {
            self.imageUrl.replaceSubrange(range, with: ip)
        }
    }
}
