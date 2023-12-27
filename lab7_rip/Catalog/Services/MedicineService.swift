//
//  MedicineService.swift
//  yourProjectName
//
//  Created by Mikhail on 04.12.2023.
//

import Foundation
// enum для пробрасывания ошибок
enum NetworkError: Error {
    case urlError
    case emptyData
}

let ip = "172.20.10.13"
final class MedicineService {
    private init() {}
    static let shared = MedicineService()

    func getMedicineData(with title: String?,
                        completion: @escaping (Result<MedicineApiModel, Error>) -> Void) {

        var urlString = "http://\(ip):8000/api/medicines"

        if let title {
            urlString += "?name=\(title)"
        }

        guard let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
            completion(.failure(NetworkError.urlError))
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            if let error {
                print("error")
                completion(.failure(error))
            }

            guard let data else {
                completion(.failure(NetworkError.emptyData))
                return
            }

            do {
                let catalogData = try JSONDecoder().decode(MedicineApiModel.self, from: data)
                completion(.success(catalogData))
            } catch let error {
                completion(.failure(error))
            }
        }).resume()
    }
}
