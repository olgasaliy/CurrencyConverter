//
//  LoaderProtocol.swift
//  CurrencyConverter
//
//  Created by Olha Salii on 12.12.2024.
//

import Foundation

protocol DataLoader {
    func fetchData<T>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) where T: Codable
}
