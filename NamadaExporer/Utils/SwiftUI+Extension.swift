//
//  SwiftUI+Extension.swift
//  NamadaExporer
//
//  Created by pnam on 08/02/2024.
//

import SwiftUI

extension Text {
    init(label: String, _ value: String) {
        self = Text("\(label): ").bold() + Text(value)
    }
    
    init(label: String, _ value: Any) {
        self = Text("\(label): ").bold() + Text(String("\(value)"))
    }
}

extension View {
    @ViewBuilder func maxWidth(_ alignment: HorizontalHStackAlignment = .leading) -> some View {
        HStack {
            switch alignment {
            case .leading:
                self
                
                Spacer()
            case .trailing:
                Spacer()
                
                self
            }
        }
        .frame(maxWidth: .infinity)
    }
}

enum HorizontalHStackAlignment {
    case leading
    case trailing
}
