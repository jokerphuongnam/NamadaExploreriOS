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
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }.inObjectScope(.container)
    container.register(URLSessionConfiguration.self) { _ in
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(60)
        configuration.timeoutIntervalForRequest = TimeInterval(60)
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = false
        configuration.allowsConstrainedNetworkAccess = false
        configuration.allowsExpensiveNetworkAccess = false
        return configuration
    }
    container.register(Session.self, name: "SupabaseSesion") { resolver in
        Session(
            configuration: resolver.resolve(URLSessionConfiguration.self)!,
            interceptor: resolver.resolve(SupabaseInterceptor.self)!
        )
    }.inObjectScope(.container)
    container.register(Session.self, name: "NamadaInfoSesion") { resolver in
        Session(
            configuration: resolver.resolve(URLSessionConfiguration.self)!
        )
    }.inObjectScope(.container)
    container.register(SupabaseNetwork.self) { resolve in
        SupabaseNetworkImpl(
            session: resolve.resolve(Session.self, name: "SupabaseSesion")!,
            decoder: resolve.resolve(JSONDecoder.self)!
        )
    }.inObjectScope(.container)
    container.register(NamadaInfoNetwork.self) { resolve in
        NamadaInfoNetworkImpl(
            session: resolve.resolve(Session.self, name: "NamadaInfoSesion")!,
            decoder: resolve.resolve(JSONDecoder.self)!
        )
    }.inObjectScope(.container)
    return container
}
