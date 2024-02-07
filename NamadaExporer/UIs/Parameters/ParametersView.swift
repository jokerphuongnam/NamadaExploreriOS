//
//  ParametersView.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI

struct ParametersView: View {
    @StateObject private var viewModel = ParametersViewModel(namadaInfoNetwork: AppDelegate.resolve())
    
    @ViewBuilder var body: some View {
        contentView
    }
    
    @ViewBuilder var contentView: some View {
        ScrollView {
            VStack(spacing: 2) {
                HStack {
                    Text("Genesis Validators")
                        .bold()
                        .font(.system(size: 32))
                    
                    Spacer()
                }.padding(.horizontal, 12)
                
                HStack {
                    Text("Chain ID shielded-expedition.88f17d1d14")
                    
                    Spacer()
                }.padding(.horizontal, 12)
                
                GenesisAccountsView(genesisAccountsState: viewModel.genesisAccountsState)
                    .onAppear(perform: viewModel.getGenesisAccounts)
                    .padding(.top, 16)
            }
            .padding(.top, 32)
        }
        .background(Color.white)
    }
}

struct ParametersView_Previews: PreviewProvider {
    static var previews: some View {
        ParametersView()
    }
}
