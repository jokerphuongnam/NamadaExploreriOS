//
//  NamadaInfoNetwork.swift
//  NamadaExporer
//
//  Created by P. Nam on 07/02/2024.
//

import Foundation
import Alamofire

protocol NamadaInfoNetwork {
    func fetchGenesisAccounts() async throws -> GenesisAccountsRequest.Response
}

final class NamadaInfoNetworkImpl: NamadaInfoNetwork, AsyncNetwork {
    let decoder: JSONDecoder
    let session: Session
    
    init(session: Session, decoder: JSONDecoder) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchGenesisAccounts() async throws -> GenesisAccountsRequest.Response {
        try await sendAsync(request: GenesisAccountsRequest())
    }
}

private extension NamadaInfoNetworkImpl {
    func sendAsync<T: Request>(
        request: T
    ) async throws -> T.Response {
        try await sendAsync(session: session, decoder: decoder, request: request)
    }
}
