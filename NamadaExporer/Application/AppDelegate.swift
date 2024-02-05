//
//  AppDelegate.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    private static var container = diRegister()
    static var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    static func resolve<T>() -> T {
        container.resolve(T.self)!
    }
}
