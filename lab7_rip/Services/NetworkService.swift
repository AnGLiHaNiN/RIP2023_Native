//
//  NetworkService.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import Moya
import UIKit
import Foundation

class NetworkService {
    static let shared = NetworkService()
    private let provider = MoyaProvider<APIService>()
    let decoder = JSONDecoder()
    
    

    // Метод для выполнения входа
    func login(username: String, password: String, completion: @escaping (Result<LoginResponseModel, Error>) -> Void) {
        provider.request(.login(username: username, password: password)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                do {
                    let model = try decoder.decode(LoginResponseModel.self, from: response.data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signUp(username: String, password: String, completion: @escaping (Result<Response, Error>) -> Void) {
        provider.request(.signUp(username: username, password: password)) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async { // Убедитесь, что обновление UI происходит в главном потоке
                switch result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(let fealure):
                    completion(.failure(fealure))
                }
            }
        }
    }

    // Метод для выполнения выхода
    func logout(completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.logout) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Метод для получения всех компонентов
    func getAllComponents(name: String?, completion: @escaping (Result<ComponentsListResponseModel, Error>) -> Void) {

        provider.request(.getAllComponents(name: name ?? "")) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                do {
                    let model = try decoder.decode(ComponentsListResponseModel.self, from: response.data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Метод для получения одного компонента по его ID
    func getOneComponent(componentID: String, completion: @escaping (Result<ComponentItemResponseModel, Error>) -> Void) {
        provider.request(.getOneComponent(componentID: componentID)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                do {
                    let model = try decoder.decode(ComponentItemResponseModel.self, from: response.data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Метод для добавления компонента в медицину
    func addToMedicine(componentID: String, completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.addToMedicine(componentID: componentID)) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Метод для получения всех медикаментов
    func getAllMedicines(completion: @escaping (Result<MedicineListResponseModel, Error>) -> Void) {
        provider.request(.getAllMedicines) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                do {
                    let model = try decoder.decode(MedicineListResponseModel.self, from: response.data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Метод для установки имени медикамента
    func setName(completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.setName) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Метод для удаления медикамента
    func deleteMedicine(completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.deleteMedicine) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Метод для изменения количества компонента
    func changeCount(componentID: String, completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.changeCount(componentID: componentID)) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Метод для удаления компонента из медицины
    func deleteFromMedicine(componentID: String, completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.deleteFromMedicine(componentID: componentID)) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Метод для подтверждения пользователя
    func userConfirm(completion: @escaping (Result<Data, Error>) -> Void) {
        provider.request(.userConfirm) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Метод для получения одного медикамента по его ID
    func getOneMedicine(medicineID: String, completion: @escaping (Result<OneMedecineAndConpnents, Error>) -> Void) {
        provider.request(.getOneMedicine(medicineID: medicineID)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                do {
                    let model = try decoder.decode(OneMedecineAndConpnents.self, from: response.data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Ошибка при загрузке изображения: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
