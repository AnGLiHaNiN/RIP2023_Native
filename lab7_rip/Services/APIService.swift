//
//  APIService.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import Moya
import UIKit
import KeychainSwift

import Moya

enum APIService: TargetType {
    case login(username: String, password: String)
    case logout
    case signUp(username: String, password: String)

    case getAllComponents(name: String)
    case getOneComponent(componentID: String)
    case addToMedicine(componentID: String)

    case getAllMedicines
    case setName
    case deleteMedicine
    case changeCount(componentID: String)
    case deleteFromMedicine(componentID: String)
    case userConfirm
    case getOneMedicine(medicineID: String)

    var baseURL: URL {
        return URL(string: "http://0.0.0.0:8000")!
    }

    var path: String {
        switch self {
        case .login:
            return "api/user/login"
        case .logout:
            return "api/user/logout"
        case .signUp:
            return "api/user/sign_up"

        case .getAllComponents:
            return "/api/components"

        case .getOneComponent(let componentID):
            return "/api/components/\(componentID)"
        case .addToMedicine(let componentID):
            return "/api/components/\(componentID)/add_to_medicine"

        case .getAllMedicines:
            return "/api/medicines"
        case .setName:
            return "/api/medicines"
        case .deleteMedicine:
            return "/api/medicines"
        case .changeCount(let componentID):
            return "/api/medicines/\(componentID)/change_count"
        case .deleteFromMedicine(let componentID):
            return "/api/medicines/delete_component/\(componentID)"
        case .userConfirm:
            return "/api/medicines/user_confirm"
        case .getOneMedicine(let medicineID):
            return "/api/medicines/\(medicineID)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getAllComponents, .getOneComponent, .getAllMedicines, .getOneMedicine, .logout:
            return .get
        case .addToMedicine, .login, .signUp:
            return .post
        case .setName, .changeCount, .userConfirm:
            return .put
        case .deleteMedicine, .deleteFromMedicine:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .login(let username, let password), .signUp(let username, let password):
            let parameters = ["login": username, "password": password]
            return .requestJSONEncodable(parameters)

        case .getOneComponent, .getAllMedicines, .getOneMedicine, .logout, .deleteMedicine, .deleteFromMedicine, .userConfirm:
            return .requestPlain

        case .getAllComponents(let name):
            let parameters = ["name": name]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)

        case .addToMedicine, .setName:
            return .requestPlain

        case .changeCount(let componentID):
            let parameters = ["componentID": componentID]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        switch self {
        case .login:
            return ["Content-Type": "application/json"]
        default:
            if let token = getToken() {
                return ["Content-Type": "application/json", "Authorization": "Bearer \(token)"]
            } else {
                return nil
            }
            
        }
    }
    
    func getToken() -> String? {
        let keychain = KeychainSwift()
        return keychain.get("authToken")
    }

    var sampleData: Data {
        return Data()
    }

    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
}
