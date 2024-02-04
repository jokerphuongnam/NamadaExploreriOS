//
//  Request.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Alamofire

protocol Request where Self.Response: Codable & Equatable {
    associatedtype Response

    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var url: URL { get }
    var parameters: Parameters { get }
    var httpHeaderFields: HTTPHeaders { get }
    var encoding: URLEncoding { get }
    var interceptor: RequestInterceptor? { get }
}

extension Request {
    var encoding: URLEncoding {
        .default
    }
    
    var httpHeaderFields: HTTPHeaders {
        [:]
    }
    
    var parameters: Parameters {
        [:]
    }
    
    var interceptor: RequestInterceptor? {
        nil
    }
    
    var url: URL {
        baseURL.appendingPathComponent(path)
    }
    
    var method: HTTPMethod {
        .get
    }
}
