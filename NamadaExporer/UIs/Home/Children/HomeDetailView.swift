//
//  HomeDetailView.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI

struct HomeDetailView: View {
    private let dataState: DataState<HomeDetailsData>
    private let retryAction: (() -> Void)?
    
    init(dataState: DataState<HomeDetailsData>, retryAction: (() -> Void)? = nil) {
        self.dataState = dataState
        self.retryAction = retryAction
    }
    
    var body: some View {
        VStack {
            contentView
                .padding(.all, 16)
            
            Spacer()
        }
    }
    
    @ViewBuilder var contentView: some View {
        switch dataState {
        case .loading:
            ProgressView()
        case .success(let data):
            dataView(data)
        case .error(let error):
            ErrorView(error: error, retryAction: retryAction)
        }
    }
    
    @ViewBuilder func dataView(_ data: HomeDetailsData) -> some View {
        VStack(spacing: 8) {
            Text(label: "Epoch", data.epoch)
                .maxWidth()
            
            Text(label: "Block Height", data.blockHeight)
                .maxWidth()
            
            Text(label: "Total Stake", "\(data.totalStake.formattedWithCommas()) NAM")
                .maxWidth()
            
            Text(label: "Validators", data.validators)
                .maxWidth()
            
            Text(label: "Governance Proposals", data.governanceProposals)
                .maxWidth()
            
            Text(label: "Chain ID", Constants.chainID)
                .maxWidth()
        }
        .frame(maxWidth: .infinity)
    }
}

#if DEBUG
struct HomeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HomeDetailView(dataState: .loading)
    }
}
#endif
