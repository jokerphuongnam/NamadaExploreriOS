//
//  NamadaInfoRequest.swift
//  NamadaExporer
//
//  Created by P. Nam on 07/02/2024.
//

import Foundation
import Alamofire

protocol NamadaInfoRequest: Request { }

extension NamadaInfoRequest {
    var baseURL: URL {
        URL(string: "https://namada.info")!
    }
    
    var encoding: URLEncoding {
        .queryString
    }
}
