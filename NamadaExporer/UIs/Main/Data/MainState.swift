//
//  MainState.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation

enum MainState: CaseIterable {
    case home
    case validators
    case blocks
    case transactions
    case governance
    case parameters
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .validators:
            return "Validators"
        case .blocks:
            return "Blocks"
        case .transactions:
            return "Transactions"
        case .governance:
            return "Governance"
        case .parameters:
            return "Parameters"
        }
    }
}
