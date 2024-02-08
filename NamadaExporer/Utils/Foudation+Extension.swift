//
//  Foudation+Extension.swift
//  NamadaExporer
//
//  Created by pnam on 08/02/2024.
//

import Foundation

private let numberFormatter = NumberFormatter()
extension Int {
    func formattedWithCommas() -> String {
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
