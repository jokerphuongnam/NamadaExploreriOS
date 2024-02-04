//
//  DI.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation
import Swinject
import SwinjectAutoregistration

func diRegister() -> Container {
    let container = Container()
    container.autoregister(ExplorerNetwork.self, initializer: ExplorerNetworkImpl.init)
    container.autoregister(Namadexer.self, initializer: NamadexerImpl.init)
    return container
}
