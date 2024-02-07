//
//  SupabaseRequest.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation
import Alamofire

protocol SupabaseRequest: Request { }

extension SupabaseRequest {
    var baseURL: URL {
        URL(string: "https://aauxuambgprwlwvfpksz.supabase.co/rest/v1/")!
    }
    
    var encoding: URLEncoding {
        .queryString
    }
}
