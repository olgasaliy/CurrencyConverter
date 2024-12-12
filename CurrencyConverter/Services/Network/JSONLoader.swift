//
//  JSONLoader.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import Foundation

class JSONLoader: DataLoader  {
    func fetchData<T>(from url: URL, completion: @escaping (Result<T, any Error>) -> Void) where T: Codable {
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch let error as URLError {
            completion(.failure(error))
        } catch {
            completion(.failure(URLError(.cannotDecodeRawData)))
        }
    }
}
