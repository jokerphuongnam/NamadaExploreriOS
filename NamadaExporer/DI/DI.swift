//
//  DI.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import Alamofire

func diRegister() -> Container {
    let container = Container()
    container.register(SupabaseInterceptor.self) { _ in
        SupabaseInterceptor()
    }.inObjectScope(.container)
    container.register(JSONDecoder.self) { _ in
        JSONDecoder()
    }.inObjectScope(.container)
    container.register(Session.self) { resolver in
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(60)
        configuration.timeoutIntervalForRequest = TimeInterval(60)
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = false
        configuration.allowsConstrainedNetworkAccess = false
        configuration.allowsExpensiveNetworkAccess = false
        
        return Session(configuration: configuration, interceptor: resolver.resolve(SupabaseInterceptor.self)!)
    }.inObjectScope(.container)
    container.autoregister(SupabaseNetwork.self, initializer: SupabaseNetworkImpl.init).inObjectScope(.container)
    container.autoregister(Namadexer.self, initializer: NamadexerImpl.init).inObjectScope(.container)
    return container
}
