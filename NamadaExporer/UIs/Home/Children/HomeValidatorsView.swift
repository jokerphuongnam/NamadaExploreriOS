//
//  HomeValidatorsView.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI

struct HomeValidatorsView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    private let validatorsState: DataState<Validators.AllField>
    private let retryAction: (() -> Void)?
    
    init(validatorsState: DataState<Validators.AllField>, retryAction: (() -> Void)? = nil) {
        self.validatorsState = validatorsState
        self.retryAction = retryAction
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text("Top 10 validators")
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
        switch validatorsState {
        case .loading:
            ProgressView()
        case .success(let data):
            validatorsView(data)
        case .error(let error):
            ErrorView(error: error) {
                retryAction?()
            }
        }
    }
    
    @ViewBuilder func validatorsView(_ validators: Validators.AllField) -> some View {
        if validators.isEmpty {
            Text("Validator is empty")
                .bold()
        } else {
            LazyVStack(spacing: 8) {
                ForEach(Array(validators.enumerated()), id: \.element.address) { index, validator in
                    ValidatorView(index: index + 1, validator)
                }
            }
        }
    }
}

#if DEBUG
struct HomeValidatorsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeValidatorsView(validatorsState: .loading)
    }
}
#endif
