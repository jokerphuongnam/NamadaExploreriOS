//
//  GenesisAccountsView.swift
//  NamadaExporer
//
//  Created by P. Nam on 07/02/2024.
//

import SwiftUI

struct GenesisAccountsView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    private let genesisAccountsState: DataState<GenesisAccounts>
    private let retryAction: (() -> Void)?
    
    init(genesisAccountsState: DataState<GenesisAccounts>, retryAction: (() -> Void)? = nil) {
        self.genesisAccountsState = genesisAccountsState
        self.retryAction = retryAction
    }
    
    var body: some View {
        genesisAccountsStateView
    }
    
    
    @ViewBuilder var genesisAccountsStateView: some View {
        switch genesisAccountsState {
        case .loading:
            ProgressView()
        case .success(let data):
            genesisAccountsView(data)
        case .error(let error):
            ErrorView(error: error) {
                retryAction?()
            }
        }
    }
    
    @ViewBuilder func genesisAccountsView(_ genesisAccounts: GenesisAccounts) -> some View {
        if genesisAccounts.isEmpty {
            Text("Validator is empty")
                .bold()
        } else {
            LazyVStack(spacing: 8) {
                ForEach(Array(genesisAccounts.enumerated()), id: \.offset) { index, genesisAccount in
                    GenesisAccountView(index: index + 1, genesisAccount)
                }
            }
        }
    }
}
