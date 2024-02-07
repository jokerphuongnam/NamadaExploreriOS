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
    
    var body: some View {
        ScrollView {
            validatorsStateView
                .padding(.top, 32)
        }
        .background(Color.white)
        .onAppear {
            viewModel.loadValidators()
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
    
    @ViewBuilder func validatorsView(_ validators: Validators) -> some View {
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
