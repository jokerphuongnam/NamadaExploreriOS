//
//  BlocksViewModel.swift
//  NamadaExporer
//
//  Created by P. Nam on 07/02/2024.
//

import Foundation

final class BlocksViewModel: ObservableObject {
    private let supabaseNetwork: SupabaseNetwork
    
    @Published var blocksState: DataState<Blocks> = .loading
    @Published var loadMoreState: LoadMoreState? = nil
    private var prepareLoadMore: PrepareLoadMore = .cannotLoadMore
    private var offset = 0
    
    init(supabaseNetwork: SupabaseNetwork) {
        self.supabaseNetwork = supabaseNetwork
    }
    
    func loadBlocks() {
        self.blocksState = .loading
        offset = 0
        Task(priority: .utility) { [weak self] in
            guard let self = self else { return }
            do {
                let blocks = try await self.supabaseNetwork.fetchBlocks(
                    selects: [
                        .height,
                        .hash,
                        .time,
                        .numTxs,
                        .proposerAddress
                    ],
                    orders: [
                        SupabaseOrder(
                            field: .height,
                            order: .desc
                        )
                    ],
                    limit: Constants.limitPage,
                    offset: self.offset
                )
                self.offset = blocks.count
                self.prepareLoadMore = .canLoadMore
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
    
    func loadMoreBlocks() {
        if prepareLoadMore == .canLoadMore {
            loadMoreState = .loading
            prepareLoadMore = .cannotLoadMore
            Task(priority: .utility) { [weak self] in
                guard let self = self else { return }
                do {
                    let blocks = try await self.supabaseNetwork.fetchBlocks(
                        selects: [
                            .height,
                            .hash,
                            .time,
                            .numTxs,
                            .proposerAddress
                        ],
                        orders: [
                            SupabaseOrder(
                                field: .height,
                                order: .desc
                            )
                        ],
                        limit: Constants.limitPage,
                        offset: self.offset
                    )
                    if blocks.isEmpty {
                        self.prepareLoadMore = .success
                        Task { @MainActor in
                            self.loadMoreState = nil
                        }
                    } else {
                        if let oldData = self.blocksState.data {
                            let newState = DataState.loadMore(dataState: self.blocksState, moreData: oldData)
                            if let newData = newState.data {
                                self.prepareLoadMore = .canLoadMore
                                self.offset = newData.count
                            }
                            Task { @MainActor in
                                self.blocksState = newState
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
}
