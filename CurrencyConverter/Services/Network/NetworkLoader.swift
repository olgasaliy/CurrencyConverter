//
//  NetworkLoader.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import Foundation

class NetworkLoader: DataLoader {
    func fetchData<T>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(error as? URLError ?? URLError(.badURL)))
                return
            }
            
            guard let data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            if T.self == Data.self, let data = data as? T {
                completion(.success(data))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(URLError(.cannotDecodeRawData)))
            }
        }
        
        dataTask.resume()
    }
    
}
