//
//  HttpRouter.swift
//  MovieList
//
//  Created by soujanya Balusu on 14/06/22.
//

import Foundation

enum HttpRouter {
    static let baseURL = "https://61efc467732d93001778e5ac.mockapi.io/movies/list"    
    case moviesList
    case favoriteMovies
    case movieImage
    
    var description: String {
        switch self {
        case .moviesList:
            return "https://61efc467732d93001778e5ac.mockapi.io/movies/list"
        case .favoriteMovies:
            return "https://61efc467732d93001778e5ac.mockapi.io/movies/favorites"
        case .movieImage:
            return "https://image.tmdb.org/t/p/w500"
        }
    }
}

