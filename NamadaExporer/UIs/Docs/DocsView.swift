//
//  DocsView.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI
import SafariServices

struct DocsView: UIViewControllerRepresentable {
    let url: URL = URL(string: "https://docs.namada.info/")!
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}
