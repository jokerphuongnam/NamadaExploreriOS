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
    
    var data: T? {
        if case let .success(data) = self {
            return data
        }
        return nil
    }
    
    var error: Error? {
        if case let .error(error) = self {
            return error
        }
        return nil
    }
    
    static func loadMore<E>(dataState: DataState<T>, moreData: T) -> DataState<T> where T == Array<E> {
        if var data = dataState.data {
            data.append(contentsOf: moreData)
            return .success(data: data)
        }
        return dataState
    }
}

enum LoadMoreState {
    case loading
    case error(error: Error)
}

enum PrepareLoadMore {
    case canLoadMore
    case cannotLoadMore
    case success
}
