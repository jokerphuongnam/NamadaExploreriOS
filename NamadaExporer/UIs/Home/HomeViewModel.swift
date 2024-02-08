//
//  HomeViewModel.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation

final class HomeViewModel: ObservableObject {
    private let supabaseNetwork: SupabaseNetwork
    
    @Published var validatorsState: DataState<Validators.AllField> = .loading
    @Published var blocksState: DataState<Blocks> = .loading
    @Published var homeDetailsState: DataState<HomeDetailsData> = .loading
    private var isDetailLoaded = false
    private var isBlocksLoadded = false
    
    init(supabaseNetwork: SupabaseNetwork) {
        self.supabaseNetwork = supabaseNetwork
    }
    
    func load10Validators() {
        self.validatorsState = .loading
        Task(priority: .utility) { [weak self] in
            guard let self = self else { return }
            do {
                let validators = try await self.get10Validator()
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
    
    func load10Blocks() {
        guard !isBlocksLoadded else { return }
        blocksState = .loading
        Task(priority: .utility) { [weak self] in
            guard let self = self else { return }
            do {
                let blocks = try await self.get10Blocks()
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
    
    func loadHomeDetails() {
        guard !isDetailLoaded else { return }
        homeDetailsState = .loading
        Task(priority: .utility) { [weak self] in
            guard let self = self else { return }
            switch self.blocksState {
            case .loading:
                do {
                    let blocks = try await self.get10Blocks()
                    await self.setHomeDataState(blocks: blocks)
                    self.isBlocksLoadded = true
                } catch {
                    self.isBlocksLoadded = true
                    Task { @MainActor in
                        self.blocksState = .error(error: error)
                        self.homeDetailsState = .error(error: error)
                    }
                }
            case .success(let blocks):
                await self.setHomeDataState(blocks: blocks)
            case .error(let error):
                isDetailLoaded = true
                Task { @MainActor in
                    self.homeDetailsState = .error(error: error)
                }
            }
        }
    }
    
    private func get10Validator() async throws -> Validators.AllField {
        try await self.supabaseNetwork.fecthValidators(
            selects: .all,
            orders: [
                SupabaseOrder(
                    field: .votingPower,
                    order: .desc
                )
            ],
            limit: 10,
            offset: 0
        )
    }
    
    private func get10Blocks() async throws -> Blocks {
        try await self.supabaseNetwork.fetchBlocks(
            selects: [
                .height,
                .hash,
                .time,
                .numTxs,
                .proposerAddress
            ],
            orders: [SupabaseOrder(field: .height, order: .desc)],
            limit: 10,
            offset: 0
        )
    }
    
    private func setHomeDataState(blocks: Blocks) async {
        do {
            let blockHeight = blocks.map { $0.height }.max()
            let validators: Validators.VotingPower = try await supabaseNetwork.fecthValidators(selects: [.votingPower], orders: [], limit: nil, offset: nil)
            
            let data = HomeDetailsData(blockHeight: blockHeight ?? 0, totalStake: Int(validators.map { Double($0.votingPower) }.reduce(0, +) / 1_000_000), validators: validators.count)
            Task { @MainActor in
                isDetailLoaded = true
                homeDetailsState = .success(data: data)
            }
        } catch {
            isDetailLoaded = true
            homeDetailsState = .error(error: error)
        }
    }
}
