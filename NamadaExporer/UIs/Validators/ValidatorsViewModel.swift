//
//  ValidatorsViewModel.swift
//  NamadaExporer
//
//  Created by pnam on 06/02/2024.
//

import Foundation

final class ValidatorsViewModel: ObservableObject {
    private let supabaseNetwork: SupabaseNetwork
    
    @Published var validatorsState: DataState<Validators> = .loading
    @Published var loadMoreState: LoadMoreState? = nil
    private var prepareLoadMore: PrepareLoadMore = .cannotLoadMore
    private var offset = 0
    
    init(supabaseNetwork: SupabaseNetwork) {
        self.supabaseNetwork = supabaseNetwork
    }
    
    func loadValidators() {
        self.validatorsState = .loading
        offset = 0
        Task(priority: .utility) { [weak self] in
            guard let self = self else { return }
            do {
                let validators = try await self.supabaseNetwork.fecthValidators(
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
                    let validators = try await self.supabaseNetwork.fecthValidators(
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
}
