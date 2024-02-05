//
//  HomeView.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel(supabaseNetwork: AppDelegate.resolve())
    
    var body: some View {
        TabView {
            HomeValidatorsView(validatorsState: viewModel.validatorsState).tabItem {
                Text("10 Validators")
            }.onAppear {
                viewModel.get10Validators()
            }
            
            HomeBlocksView().tabItem {
                Text("10 Blocks")
            }
            
            HomeDetailView().tabItem {
                Text("Details")
            }
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
