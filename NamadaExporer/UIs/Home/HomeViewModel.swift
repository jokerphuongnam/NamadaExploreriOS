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
    @Published var blocksState: DataState<Blocks> = .loading
    var isDetailLoaded = false
    
    init(supabaseNetwork: SupabaseNetwork) {
        self.supabaseNetwork = supabaseNetwork
    }
    
    func get10Validators() {
        self.validatorsState = .loading
        Task(priority: .utility) { [weak self] in
            guard let self = self else { return }
            do {
                let validators = try await self.supabaseNetwork.fecthValidators(selects: .all, orders: [SupabaseOrder(field: .votingPower, order: .desc)], limit: 10, offset: 0)
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
    
    func get10Blocks() {
        blocksState = .loading
        Task(priority: .utility) { [weak self] in
            guard let self = self else { return }
            do {
                let blocks = try await self.supabaseNetwork.fetchBlocks(selects: [SupabaseSelect]([.height, .hash, .time, .numTxs, .proposerAddress]), orders: [SupabaseOrder(field: .height, order: .desc)], limit: 10, offset: 0)
                Task { @MainActor in
                    self.blocksState = .success(data: blocks)
                }
            } catch {
                Task { @MainActor in
                    self.blocksState = .error(error: error)
                }
            }
        }
    }
    
    func getHomeDetails() {
        
    }
}
