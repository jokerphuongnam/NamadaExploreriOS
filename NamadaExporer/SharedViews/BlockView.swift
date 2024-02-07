//
//  BlockView.swift
//  NamadaExporer
//
//  Created by P. Nam on 07/02/2024.
//

import SwiftUI

@ViewBuilder func BlockView(index: Int, now: Date, _ block: Block) -> some View {
    HStack(spacing: 4) {
        Text(String(block.height))
            .bold()
            .font(.system(size: 24))
        
        VStack(spacing: 2) {
            Text(block.hash)
                .bold()
                .lineLimit(1)
            
            Text(block.proposerAddress)
                .lineLimit(1)
            
            HStack(spacing: 8) {
                Text(String(block.numTxs))
                
                Spacer()
                if let date = block.time.date {
                    Text((date - now).timeAgoString())
                } else {
                    Text(block.time)
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
