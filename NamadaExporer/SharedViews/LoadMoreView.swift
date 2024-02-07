//
//  LoadMoreView.swift
//  NamadaExporer
//
//  Created by P. Nam on 07/02/2024.
//

import SwiftUI

@ViewBuilder func LoadMoreView(loadMoreState: LoadMoreState, retryAction: (() -> Void)? = nil) -> some View {
    switch loadMoreState {
    case .loading:
        ProgressView()
    case .error(let error):
        ErrorView(error: error, retryAction: retryAction)
    }
}
