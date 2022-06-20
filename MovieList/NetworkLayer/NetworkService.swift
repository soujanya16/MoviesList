//
//  NetworkService.swift
//  MovieList
//
//  Created by soujanya Balusu on 14/06/22.
//

import Foundation

struct NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func loadMovieesList(completion: @escaping(Result<MovieResponse,Error>) -> Void) {
        loadResources(from: HttpRouter.moviesList.description,completion: completion)
    }
    
    func loadFavoritesList(completion: @escaping(Result<FavoriteResponse,Error>) -> Void) {
        loadResources(from: HttpRouter.favoriteMovies.description,completion: completion)
    }
    
    private func loadResources<T: Decodable>(from path: String,
                                             completion: @escaping(Result<T,Error>) -> Void) {
        if let url = path.asURL  {
            
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, _, error) in
                
                if let error = error {
                    completion(.failure(error))
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(T.self, from: data)
                        completion(.success(response))
                    } catch DecodingError.dataCorrupted(let context) {
                        print(context)
                    } catch DecodingError.keyNotFound(let key, let context) {
                        debugPrint("Key '\(key)' not found:", context.debugDescription)
                    } catch DecodingError.valueNotFound(let value, let context) {
                        debugPrint("Value '\(value)' not found:", context.debugDescription)
                    } catch DecodingError.typeMismatch(let type, let context) {
                        debugPrint("Type '\(type)' mismatch:", context.debugDescription)
                    } catch {
                        debugPrint("error: ", error)
                    }
                }
            }
            urlSession.resume()
        }
    }
}
