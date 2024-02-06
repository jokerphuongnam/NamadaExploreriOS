//
//  HomeView.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel(supabaseNetwork: AppDelegate.resolve())
    @State private var currentState = HomeState.validators
    @State private var isPresentDetail = false
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        ZStack(alignment: .bottom) {
            HomeValidatorsView(validatorsState: viewModel.validatorsState) {
                viewModel.get10Validators()
            }
            .opacity(currentState == .validators ? 1 : 0)
            .onAppear(perform: viewModel.get10Validators)
            
            HomeBlocksView(blocksState: viewModel.blocksState) {
                viewModel.get10Blocks()
            }
            .opacity(currentState == .blocks ? 1 : 0)
            .onAppear(perform: viewModel.get10Blocks)
            
            VStack(spacing: 0) {
                Color.gray.frame(height: 1)
                
                selectView
                    .frame(height: 52)
                    .padding(.bottom, safeAreaInsets.bottom)
                    .padding(.horizontal, 8)
                    .ignoresSafeArea()
                    .background(Color.white)
            }
            .ignoresSafeArea()
        }.sheet(isPresented: $isPresentDetail) {
            NavigationView {
                HomeDetailView()
                    .navigationTitle("Details")
            }
            .onAppear {
                if !viewModel.isDetailLoaded {
                    viewModel.getHomeDetails()
                }
            }
        }
    }
    
    @ViewBuilder var selectView: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(HomeState.allCases, id: \.self) { state in
                    Button {
                        currentState = state
                    } label: {
                        ZStack {
                            Text(state.rawValue)
                                .foregroundColor(currentState == state ? .black: .gray)
                                .bold()
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
                                .padding(.all, 16)
                                .frame(width: geometry.size.width / 3)
                        }
                    }
                }
                
                Button {
                    isPresentDetail = true
                } label: {
                    ZStack {
                        Text("Home Details")
                            .foregroundColor(.gray)
                            .bold()
                            .lineLimit(0)
                            .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
                            .padding(.all, 16)
                            .frame(width: geometry.size.width / 3)
                    }
                }
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
