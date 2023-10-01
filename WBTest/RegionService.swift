//
//  RegionService.swift
//  WBTest
//
//  Created by Al Stark on 30.09.2023.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case cannotParse
}

final class RegionService {
    static func getRegions(
        completion: @escaping (_ result: Result<[RegionTableModel], NetworkError>
        ) -> Void) {
        
        guard let url = URL(
            string: "https://vmeste.wildberries.ru/api/guide-service/v1/getBrands"
        ) else {
            completion(.failure(.urlError))
            return
        }
        
        URLSession.shared.dataTask(
            with: url,
            completionHandler: { data, _, error in
                if error == nil,
                   let data = data,
                   let resultData = try? JSONDecoder().decode(
                    RegionsTableModel.self,
                    from: data
                   ) {
                    completion(.success(resultData.brands))
                } else {
                    completion(.failure(.cannotParse))
                }
            }
        ).resume()
    }
}
