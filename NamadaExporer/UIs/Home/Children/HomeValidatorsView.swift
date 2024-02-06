//
//  HomeValidatorsView.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI

struct HomeValidatorsView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    private let validatorsState: DataState<Validators>
    private let retryAction: (() -> Void)?
    
    init(validatorsState: DataState<Validators>, retryAction: (() -> Void)? = nil) {
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
    
    @ViewBuilder func validatorsView(_ validators: Validators) -> some View {
        if validators.isEmpty {
            Text("Validator is empty")
                .bold()
        } else {
            LazyVStack(spacing: 8) {
                ForEach(Array(validators.enumerated()), id: \.element.address) { index, validator in
                    validatorView(index: index + 1, validator)
                }
            }
        }
    }
    
    @ViewBuilder func validatorView(index: Int, _ validator: Validator) -> some View {
        HStack(spacing: 4) {
            Text(String(index))
                .bold()
                .font(.system(size: 24))
            
            VStack(spacing: 2) {
                Text(validator.address)
                    .bold()
                    .lineLimit(1)
                Text(validator.pubKey)
                    .lineLimit(1)
                
                Color.clear.frame(height: 6)
                
                HStack(spacing: 8) {
                    Text(String(validator.height))
                    
                    VStack(spacing: 4) {
                        Text(String(validator.votingPower))
                        Text(String(validator.proposerPriority))
                    }
                    
                    Spacer()
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
struct HomeValidatorsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeValidatorsView(validatorsState: .loading)
    }
}
#endif
