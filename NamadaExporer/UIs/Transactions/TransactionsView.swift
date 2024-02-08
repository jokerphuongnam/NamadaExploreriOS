//
//  TransactionsView.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI

struct TransactionsView: View {
    @State private var currentState = TransactionsState.transfers
    
    var body: some View {
        ZStack(alignment: .top) {
            tabView
                .zIndex(2)
            
            contentView
                .zIndex(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder var tabView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(TransactionsState.allCases, id: \.self) { state in
                    let isSelected = state == currentState
                    let text = isSelected ? Text(state.title).bold() : Text(state.title)
                    
                    Button {
                        currentState = state
                    } label: {
                        text
                            .foregroundColor(isSelected ? Color.yellow : Color.black)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(isSelected ? Color.black : Color.cyan)
                            .padding(4)
                            .cornerRadius(8)
                    }
                        
                }
            }
            
            Color.gray
                .frame(height: 1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(Color.black)
    }
    
    @ViewBuilder var contentView: some View {
        ZStack {
            Color.black
                .opacity(currentState == .transfers ? 1 : 0)
            
            Color.yellow
                .opacity(currentState == .bonds ? 1 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView()
    }
}
