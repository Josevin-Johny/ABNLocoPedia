//
//  NetworkSerivce.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 26/10/2025.
//
import Foundation
import Combine

enum NetworkError : LocalizedError {
    case invalidURL
    case networkerror(Error)
    case invalidResponse
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "Invalid URL"
        case .networkerror(let error):
            return "Network Error \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid Response"
        case .decodingError(let error):
            return "Decoding Error \(error.localizedDescription)"
        }
    }
}

protocol NetworkSerivceProtocol {
    func fetch<T: Decodable>(from url: URL) -> AnyPublisher<T, Error>
}

final class NetworkSerivce : NetworkSerivceProtocol {
    private let session : URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T>(from url: URL) -> AnyPublisher<T, any Error> where T : Decodable {
        session.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpsResponse = response as? HTTPURLResponse,
                      httpsResponse.statusCode == 200 else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return NetworkError.decodingError(error)
                }
                return NetworkError.networkerror(error)
            }
            .eraseToAnyPublisher()
    }
}
