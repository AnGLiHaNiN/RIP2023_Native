//
//  LoginResponseModel.swift
//  lab7_rip
//
//  Created by Михаил on 31.01.2024.
//

import Foundation

struct LoginResponseModel: Codable {
    let accessToken, tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}
