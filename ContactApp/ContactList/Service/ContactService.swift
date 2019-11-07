//
//  ContactService.swift
//  ContactApp
//
//  Created by Ari Fajrianda Alfi on 07/11/19.
//  Copyright © 2019 Tokopedia Academy. All rights reserved.
//

import Foundation

protocol ContactService {
    func fetchContactList(completion: @escaping (Result<[Contact], Error>) -> Void )
}

enum ContactServiceError: Error {
    case missingData
}

class NetworkContactService: ContactService {
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    
    func fetchContactList(completion: @escaping (Result<[Contact], Error>) -> Void) {
        let url = URL(string: "https://gist.githubusercontent.com/99ridho/cbbeae1fa014522151e45a766492233c/raw/e3ea7cf52a7de7872863f9b2350f2c434eb0fe2c/contacts.json")!
        
        let task = URLSession.shared.dataTask(with: url) { [jsonDecoder] (data, response, error) in
            if let theError = error {
                completion(.failure(theError))
                return
            }
            
            guard let theData = data else {
                completion(.failure(ContactServiceError.missingData))
                return
            }
            
            do {
                let response = try jsonDecoder.decode(ContactListResponse.self, from: theData)
                let contacts = response.data
                
                completion(Result.success(contacts))
            } catch (let decodeError) {
                completion(.failure(decodeError))
            }
        }
        
        task.resume()

    }
}
