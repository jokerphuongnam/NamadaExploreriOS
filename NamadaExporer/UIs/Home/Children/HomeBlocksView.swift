//
//  HomeBlocksView.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI

struct HomeBlocksView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    private var blocksState: DataState<Blocks>
    private let now: Date = Date()
    
    init(blocksState: DataState<Blocks>) {
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
            Text(String("\(error)"))
        }
    }
    
    @ViewBuilder func blocksView(_ validators: Blocks) -> some View {
        LazyVStack(spacing: 8) {
            ForEach(Array(validators.enumerated()), id: \.element.height) { index, block in
                blockView(index: index + 1, block)
            }
        }
    }
    
    @ViewBuilder func blockView(index: Int, _ block: Block) -> some View {
        HStack(spacing: 4) {
            Text(String(block.height))
                .bold()
                .font(.system(size: 24))
            
            VStack(spacing: 2) {
                Text(block.hash)
                    .bold()
                    .lineLimit(1)
                
                Text(block.proposerAddress)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(String(block.numTxs))
                    
                    Spacer()
                    
                    Text((block.date - now).timeAgoString())
                }
            }
        }
        .padding(.all, 8)
        .background(Color.yellow)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.black, lineWidth: 1)
        )
        .padding(.horizontal, 12)
    }
}

#if DEBUG
struct HomeBlocksView_Previews: PreviewProvider {
    static var previews: some View {
        HomeBlocksView(blocksState: .loading)
    }
}
#endif
