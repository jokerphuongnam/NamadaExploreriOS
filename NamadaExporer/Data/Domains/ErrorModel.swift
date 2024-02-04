//
//  ErrorModel.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation

struct ErrorModel: Error {
    var message: String = ""
    var code: Int = 0
}

enum AppError: Error {
    case ownerNil
    case canNotConvertObject
    case noPrizes
}

enum NetworkErrorCase: Error {
    case cannotConnectionInternet
    case cannotConnectToHost
    case timeOut
}

enum LocalErrorCase: Error {
    case notFound
}
