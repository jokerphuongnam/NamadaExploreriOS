//
//  GenesisAccountView.swift
//  NamadaExporer
//
//  Created by P. Nam on 07/02/2024.
//

import SwiftUI

@ViewBuilder func GenesisAccountView(index: Int, _ genesisAccount: GenesisAccount) -> some View {
    HStack(spacing: 4) {
        Text(String(index))
            .bold()
            .font(.system(size: 24))
        
        VStack(spacing: 2) {
            HStack {
                Text(genesisAccount.alias)
                    .bold()
                    .lineLimit(1)
                
                Spacer()
            }
            
            VStack(spacing: 4) {
                Text(genesisAccount.hashedKey)
                    .lineLimit(1)
                Text(genesisAccount.address)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Text(genesisAccount.bondAmount)
                    
                    Spacer()
                    
                    if let commissionRate = Double(genesisAccount.commissionRate), let maxCommissionRateChange = Double(genesisAccount.maxCommissionRateChange) {
                        Text(String("\(commissionRate * 100)% / \(maxCommissionRateChange * 100)%"))
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Text(genesisAccount.netAddress)
                }
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
