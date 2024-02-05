//
//  SupabaseInterceptor.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Alamofire

final class SupabaseInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, using state: RequestAdapterState, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFhdXh1YW1iZ3Byd2x3dmZwa3N6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODE3MjI1NTMsImV4cCI6MTk5NzI5ODU1M30.R5SJhC6QmHDeHxpIvCdCSGx6Lhd5BFHWMzlmPKvWpBc", forHTTPHeaderField: "Apikey")
        urlRequest.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFhdXh1YW1iZ3Byd2x3dmZwa3N6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODE3MjI1NTMsImV4cCI6MTk5NzI5ODU1M30.R5SJhC6QmHDeHxpIvCdCSGx6Lhd5BFHWMzlmPKvWpBc", forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
}
