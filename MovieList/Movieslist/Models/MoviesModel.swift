//
//  MoviesModel.swift
//  MovieList
//
//  Created by soujanya Balusu on 14/06/22.
//

import Foundation

struct Favorite : Codable {
    let id: Int?
    enum CodingKeys: String, CodingKey{
        case id = "id"
    }
}

public struct FavoriteResponse: Codable{
    let results: [Favorite]
}

struct MovieDetails: Codable{
    var backdrop_path: String = ""
    var id: Int = 0
    var original_language: String = ""
    var original_title: String = ""
    var overview: String = ""
    var popularity: Float = 0.0
    var poster_path: String = ""
    var release_date: String = ""
    var title: String = ""
    var rating: Float = 0.0
    var isWatched: Bool = false

    enum CodingKeys: String, CodingKey{
        case poster_path = "poster_path"
        case backdrop_path = "backdrop_path"
        case id = "id"
        case original_language = "original_language"
        case original_title = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case release_date = "release_date"
        case title = "title"
        case rating = "rating"
        case isWatched = "isWatched"
    }

}

public struct MovieResponse: Codable{
    let results: [MovieDetails]
}

