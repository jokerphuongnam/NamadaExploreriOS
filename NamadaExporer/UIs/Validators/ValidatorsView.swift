//
//  ValidatorsView.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI

struct ValidatorsView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject private var viewModel = ValidatorsViewModel(supabaseNetwork: AppDelegate.resolve())
    
    @State private var isPresentDetail = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Button {
                    isPresentDetail.toggle()
                } label: {
                    Text("Home Details")
                        .font(.system(size: 32))
                        .bold()
                        .foregroundColor(.yellow)
                        .maxWidth()
                }
                .padding(.top, 32)
                .padding(.leading, 16)
                
                validatorsStateView
                    .padding(.top, 32)
            }
        }
        .background(Color.white)
        .onAppear {
            viewModel.loadValidators()
        }.sheet(isPresented: $isPresentDetail) {
            NavigationView {
                HomeDetailView(
                    dataState: viewModel.homeDetailsState
                ) {
                    viewModel.loadHomeDetails()
                }
                .navigationTitle("Namada Details")
            }
            .onAppear {
                viewModel.loadHomeDetails()
            }
        }
    }
    
    @ViewBuilder var validatorsStateView: some View {
        switch viewModel.validatorsState {
        case .loading:
            ProgressView()
        case .success(let data):
            validatorsView(data)
        case .error(let error):
            ErrorView(error: error) {
                viewModel.loadMoreValidators()
            }
        }
    }
    
    @ViewBuilder func validatorsView(_ validators: Validators.AllField) -> some View {
        if validators.isEmpty {
            Text("Validator is empty")
                .bold()
        } else {
            LazyVStack(spacing: 8) {
                ForEach(Array(validators.enumerated()), id: \.offset) { index, validator in
                    ValidatorView(index: index + 1, validator)
                        .onAppear {
                            if validators.count - 10 < index {
                                viewModel.loadMoreValidators()
                            }
                        }
                }
                
                if let loadMoreState = viewModel.loadMoreState {
                    LoadMoreView(loadMoreState: loadMoreState, retryAction: viewModel.loadMoreValidators)
                }
            }
        }
    }
}

#if DEBUG
struct ValidatorsView_Previews: PreviewProvider {
    static var previews: some View {
        ValidatorsView()
    }
}
#endif
