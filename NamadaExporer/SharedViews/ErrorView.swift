//
//  ErrorView.swift
//  NamadaExporer
//
//  Created by pnam on 06/02/2024.
//

import SwiftUI

@ViewBuilder func ErrorView(error: Error, retryAction: (() -> Void)? = nil) -> some View {
    VStack {
        Text(String("\(error)"))
            .foregroundColor(Color.red)
        
        Button {
            retryAction?()
        } label: {
            Text("Retry")
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.yellow)
                .cornerRadius(4)
        }
    }
}

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: NSError())
    }
}
#endif
