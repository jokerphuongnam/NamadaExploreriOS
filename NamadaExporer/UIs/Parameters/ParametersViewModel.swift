//
//  ParametersViewModel.swift
//  NamadaExporer
//
//  Created by P. Nam on 07/02/2024.
//

import Foundation

final class ParametersViewModel: ObservableObject {
    private let namadaInfoNetwork: NamadaInfoNetwork
    
    @Published var genesisAccountsState: DataState<GenesisAccounts> = .loading
    
    init(namadaInfoNetwork: NamadaInfoNetwork) {
        self.namadaInfoNetwork = namadaInfoNetwork
    }
    
    func loadGenesisAccounts() {
        self.genesisAccountsState = .loading
        Task(priority: .utility) { [weak self] in
            guard let self = self else { return }
            do {
                let genesisAccounts = try await self.namadaInfoNetwork.fetchGenesisAccounts()
                Task { @MainActor in
                    self.genesisAccountsState = .success(data: genesisAccounts)
                }
            } catch {
                Task { @MainActor in
                    self.genesisAccountsState = .error(error: error)
                }
            }
        }
    }
}
