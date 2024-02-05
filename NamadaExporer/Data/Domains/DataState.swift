//
//  DataState.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation

enum DataState<T> {
    case loading
    case success(data: T)
    case error(error: Error)
}
