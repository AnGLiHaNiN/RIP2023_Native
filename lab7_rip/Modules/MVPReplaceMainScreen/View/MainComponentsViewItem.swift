//
//  MainComponentsViewItem.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import Foundation

enum MainComponentsViewState: Hashable {
    case data([MainComponentsViewItem])
}

enum MainComponentsViewItem: Hashable {
    case componentItem(ComponentCell.DisplayData)
    case medecineItem(MedicineItemResponseModel)
    case basketItem(BasketCell.DisplayData)
}
