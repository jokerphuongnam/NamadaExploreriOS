//
//  ValidatorView.swift
//  NamadaExporer
//
//  Created by P. Nam on 07/02/2024.
//

import SwiftUI

@ViewBuilder func ValidatorView(index: Int, _ validator: Validator) -> some View {
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
