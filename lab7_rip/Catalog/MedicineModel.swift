//
//  MedicineModel.swift
//  yourProjectName
//
//  Created by Mikhail on 04.12.2023.
//

import Foundation

final class MedicineModel {
    private let catalogNetworkManager = MedicineService.shared
    
    func loadMedicine(with title: String? = nil,
                     completion: @escaping (Result<[MedicineUIModel], Error>) -> Void) {
        catalogNetworkManager.getMedicineData(with: title) { result in
            switch result {
            case .success(let data):

                let catalogUIModels = data.medicines.map { catalogApiModel in
                    MedicineUIModel(name: catalogApiModel.name,
                                    imageUrl: catalogApiModel.imageUrl,
                                    dosage: catalogApiModel.dosage,
                                    amount: catalogApiModel.amount,
                                    manufacturer: catalogApiModel.manufacturer)
                }
                completion(.success(catalogUIModels))
            case .failure(let error):
                print(error)
            }
        }
    }
}
