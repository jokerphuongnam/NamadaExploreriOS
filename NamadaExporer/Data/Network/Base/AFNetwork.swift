//
//  AFNetwork.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation
import Alamofire

protocol AFNetwork {
    
}

extension AFNetwork {
    @discardableResult
    func send<T: Request>(
        session: Session,
        decoder: JSONDecoder,
        request: T,
        completion: @escaping (Result<T.Response, Error>) -> ()
    ) -> DataRequest {
        session.request(
            request.url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.encoding,
            headers: request.httpHeaderFields,
            interceptor: request.interceptor
        )
#if DEBUG
        .cURLDescription(on: DispatchQueue.init(label: "\(self.self)", qos: .background)) { description in
            print("Request \(description)")
        }
#endif
        .responseDecodable(of: T.Response.self) { response in
            guard let data = response.data else {
                completion(.failure(NetworkError.dataNotExist))
                return
            }
            
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(NetworkError.statusCodeNotExist))
                return
            }
            switch statusCode {
            case 200..<500:
                do {
#if DEBUG
                    DispatchQueue(label: String(describing: Self.self), qos: .background).async {
                        if let returnData = String(data: data, encoding: .utf8) {
                            print(String(returnData))
                        } else {
                            print("Can't parse to String data")
                        }
                    }
#endif
                    let res = try decoder.decode(T.Response.self, from: data)
                    completion(.success(res))
                } catch {
                    completion(.failure(NetworkError.unknownError(ResponseError(error.localizedDescription, statusCode: statusCode))))
                }
            default:
                completion(.failure(NetworkError.otherError(.init(false, statusCode: statusCode))))
            }
        }
    }
}

protocol AsyncNetwork: AFNetwork, AnyObject {
}

extension AsyncNetwork {
    func sendAsync<T: Request>(
        session: Session,
        decoder: JSONDecoder,
        request: T
    ) async throws -> T.Response {
        var requestHandler: DataRequest?
        return try await withTaskCancellationHandler { [requestHandler] in
            requestHandler?.cancel()
        } operation: {
            try await withCheckedThrowingContinuation { [weak self] continuation in
                guard let self = self else { return }
                requestHandler = self.send(session: session, decoder: decoder, request: request) { [weak self] result in
                    guard self != nil else { return }
                    switch result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}
