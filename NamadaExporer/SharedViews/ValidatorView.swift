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
            
            HStack(spacing: 4) {
                Spacer()
                Text("Piority: \(String(validator.proposerPriority))")
                    .font(.system(size: 10))
            }
            
            Text(validator.address)
                .bold()
                .lineLimit(1)
            
            Text(validator.pubKey)
                .lineLimit(1)
            
            HStack(spacing: 8) {
                Text(String(validator.height))
                
                Spacer()
                
                Text(String(validator.votingPower))
            }
            .padding(.top, 6)
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
