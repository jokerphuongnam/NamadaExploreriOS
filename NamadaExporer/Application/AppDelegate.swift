//
//  AppDelegate.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    private lazy var container = diRegister()
    var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    func resolve<T>() -> T {
        container.resolve(T.self)!
    }
}
