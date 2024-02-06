//
//  SupabaseNetwork.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation
import Alamofire

protocol SupabaseNetwork {
    func fecthValidators(selects: [SupabaseSelect], orders: [SupabaseOrder], limit: Int, offset: Int) async throws -> ValidatorsRequest.Response
    func fetchBlocks(selects: [SupabaseSelect], orders: [SupabaseOrder], limit: Int, offset: Int) async throws -> BlocksRequest.Response
}

final class SupabaseNetworkImpl: SupabaseNetwork, AsyncNetwork {
    let decoder: JSONDecoder
    let session: Session
    
    init(session: Session, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
    func fecthValidators(selects: [SupabaseSelect], orders: [SupabaseOrder], limit: Int, offset: Int) async throws -> ValidatorsRequest.Response {
        try await sendAsync(request: ValidatorsRequest(selects: selects, orders: orders, limit: limit, offset: offset))
    }
    
    func fetchBlocks(selects: [SupabaseSelect], orders: [SupabaseOrder], limit: Int, offset: Int) async throws -> BlocksRequest.Response {
        try await sendAsync(request: BlocksRequest(selects: selects, orders: orders, limit: limit, offset: offset))
    }
}

private extension SupabaseNetworkImpl {
    func sendAsync<T: Request>(
        request: T
    ) async throws -> T.Response {
        try await sendAsync(session: session, decoder: decoder, request: request)
    }
}
