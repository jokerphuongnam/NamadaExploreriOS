//
//  BlocksView.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI

struct BlocksView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject private var viewModel = BlocksViewModel(supabaseNetwork: AppDelegate.resolve())
    
    var body: some View {
        ScrollView {
            blocksStateView
            .padding(.top, 32)
        }
        .background(Color.white)
        .onAppear {
            viewModel.loadBlocks()
        }
    }
    
    @ViewBuilder var blocksStateView: some View {
        switch viewModel.blocksState {
        case .loading:
            ProgressView()
        case .success(let data):
            blocksView(data)
        case .error(let error):
            ErrorView(error: error) {
                viewModel.loadMoreBlocks()
            }
        }
    }
    
    @ViewBuilder func blocksView(_ blocks: Blocks) -> some View {
        if blocks.isEmpty {
            Text("Validator is empty")
                .bold()
        } else {
            LazyVStack(spacing: 8) {
                let now = Date()
                ForEach(Array(blocks.enumerated()), id: \.offset) { index, block in
                    BlockView(index: index + 1, now: now, block)
                        .onAppear {
                            if blocks.count - 10 < index {
                                viewModel.loadMoreBlocks()
                            }
                        }
                }
                
                if let loadMoreState = viewModel.loadMoreState {
                    LoadMoreView(loadMoreState: loadMoreState, retryAction: viewModel.loadMoreBlocks)
                }
            }
        }
    }
}

#if DEBUG
struct BlocksView_Previews: PreviewProvider {
    static var previews: some View {
        BlocksView()
    }
}
#endif
