//
//  HomeViewModel.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation

final class HomeViewModel: ObservableObject {
    private let supabaseNetwork: SupabaseNetwork
    
    @Published var validatorsState: DataState<Validators> = .loading
    
    init(supabaseNetwork: SupabaseNetwork) {
        self.supabaseNetwork = supabaseNetwork
    }
    
    func get10Validators() {
        self.validatorsState = .loading
        Task(priority: .utility) { [weak self] in
            guard let self = self else { return }
            do {
                let validators = try await self.supabaseNetwork.fecthValidators(select: nil, order: .desc, limit: 10)
                Task { @MainActor in
                    self.validatorsState = .success(data: validators)
                }
            } catch {
                Task { @MainActor in
                    self.validatorsState = .error(error: error)
                }
            }
        }
    }
}
