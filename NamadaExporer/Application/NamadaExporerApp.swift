//
//  NamadaExporerApp.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import SwiftUI

@main
struct NamadaExporerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
            }
        }
    }
}
