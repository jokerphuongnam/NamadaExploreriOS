//
//  ValidatorsViewModel.swift
//  NamadaExporer
//
//  Created by pnam on 06/02/2024.
//

import Foundation

final class ValidatorsViewModel: ObservableObject {
    private let supabaseNetwork: SupabaseNetwork
    
    @Published var validatorsState: DataState<Validators.AllField> = .loading
    @Published var loadMoreState: LoadMoreState? = nil
    @Published var homeDetailsState: DataState<HomeDetailsData> = .loading
    private var prepareLoadMore: PrepareLoadMore = .cannotLoadMore
    private var offset = 0
    private var isDetailLoaded = false
    
    init(supabaseNetwork: SupabaseNetwork) {
        self.supabaseNetwork = supabaseNetwork
    }
    
    func loadValidators() {
        self.validatorsState = .loading
        offset = 0
        Task(priority: .utility) { [weak self] in
            guard let self = self else { return }
            do {
                let validators: Validators.AllField = try await self.supabaseNetwork.fecthValidators(
                    selects: .all,
                    orders: [
                        SupabaseOrder(
                            field: .votingPower,
                            order: .desc
                        ),
                        SupabaseOrder(
                            field: .height,
                            order: .desc
                        )
                    ],
                    limit: Constants.limitPage,
                    offset: self.offset
                )
                self.offset = validators.count
                self.prepareLoadMore = .canLoadMore
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
    
    func loadMoreValidators() {
        if prepareLoadMore == .canLoadMore {
            loadMoreState = .loading
            prepareLoadMore = .cannotLoadMore
            Task(priority: .utility) { [weak self] in
                guard let self = self else { return }
                do {
                    let validators: Validators.AllField = try await self.supabaseNetwork.fecthValidators(
                        selects: .all,
                        orders: [
                            SupabaseOrder(
                                field: .votingPower,
                                order: .desc
                            ),
                            SupabaseOrder(
                                field: .height,
                                order: .desc
                            )
                        ],
                        limit: Constants.limitPage,
                        offset: self.offset
                    )
                    if validators.isEmpty {
                        self.prepareLoadMore = .success
                        Task { @MainActor in
                            self.loadMoreState = nil
                        }
                    } else {
                        if let oldData = self.validatorsState.data {
                            let newState = DataState.loadMore(dataState: self.validatorsState, moreData: oldData)
                            if let newData = newState.data {
                                self.prepareLoadMore = .canLoadMore
                                self.offset = newData.count
                            }
                            Task { @MainActor in
                                self.validatorsState = newState
                                self.loadMoreState = nil
                            }
                        }
                    }
                } catch {
                    Task { @MainActor in
                        self.loadMoreState = .error(error: error)
                    }
                }
            }
        }
    }
    
    func loadHomeDetails() {
        guard !isDetailLoaded else { return }
        homeDetailsState = .loading
        Task(priority: .utility) { [weak self] in
            guard let self = self else { return }
            do {
                let blocks = try await self.get10Blocks()
                await self.setHomeDataState(blocks: blocks)
            } catch {
                Task { @MainActor in
                    self.homeDetailsState = .error(error: error)
                }
            }
        }
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
