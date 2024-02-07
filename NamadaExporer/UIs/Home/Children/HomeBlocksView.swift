//
//  HomeBlocksView.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI

struct HomeBlocksView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    private let blocksState: DataState<Blocks>
    private let retryAction: (() -> Void)? = nil
    
    init(blocksState: DataState<Blocks>, retryAction: (() -> Void)? = nil) {
        self.blocksState = blocksState
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text("Top 10 Blocks")
                    .bold()
                    .font(.system(size: 32))
                
                validatorsStateView
            }
            .padding(.top, 32)
            .padding(.bottom, 52 + 8 + safeAreaInsets.bottom)
        }
        .background(Color.white)
    }
    
    
    @ViewBuilder var validatorsStateView: some View {
        switch blocksState {
        case .loading:
            ProgressView()
        case .success(let data):
            blocksView(data)
        case .error(let error):
            ErrorView(error: error) {
                retryAction?()
            }
        }
    }
    
    @ViewBuilder func blocksView(_ blocks: Blocks) -> some View {
        if blocks.isEmpty {
            Text("Block is empty")
                .bold()
        } else {
            LazyVStack(spacing: 8) {
                let now: Date = Date()
                ForEach(Array(blocks.enumerated()), id: \.element.height) { index, block in
                    BlockView(index: index + 1, now: now, block)
                }
            }
        }
    }
}

#if DEBUG
struct HomeBlocksView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBlocksView(blocksState: .loading)
    }
}
#endif
