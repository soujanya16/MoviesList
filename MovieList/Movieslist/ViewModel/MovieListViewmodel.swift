//
//  MovieListViewmodel.swift
//  MovieList
//
//  Created by soujanya Balusu on 16/06/22.
//

import Foundation
import UIKit

typealias tupleVar = (String, String , Bool)
protocol NetworkFetcher {
    func getMovies()
}
protocol MovieslistViemodelOutputProtocol {
    func getCellObject(indexPath: IndexPath) ->  tupleVar
    func numberOfItems(section: Int) -> Int
    func getSectionTitle(section: Int) -> String
    var sectionNamesCount: Int? { get }
    var getSelectedMovieObject: MovieDetails? { get }
    var headerHeight: CGFloat? { get }
}

protocol MovieslistViemodelInputProtocol {
    func selectedMovieIndex(_ index: Int, section: Int)
}

final class MovieslistViemodel: MovieslistViemodelOutputProtocol {
    var input: MovieslistViemodelInputProtocol { self }
    var output: MovieslistViemodelOutputProtocol { self }
    var networkService: NetworkFetcher { self }
    ///  notify reloadTable to update the UI on data change.
    var reloadTable: DynamicObserver<Bool> = DynamicObserver(false)
    /// Movies list
    var favoritesList = [MovieDetails]()
    var watchedMoview = [MovieDetails]()
    private var toWatchMoview = [MovieDetails]()
    private var results = [MovieDetails]()
    private var result = [MovieDetails]()
    private var movieObj = MovieDetails()
    private var sectionHeight: CGFloat = 0.0
    private var rowHeight: CGFloat = 0.0
    private var sectionNames = ["Favorites","Watched","To Watch"]
    private  var favoriteIds = [Favorite]()
    
   
    var sectionNamesCount: Int?{
        return sectionNames.count
    }
    
    var headerHeight: CGFloat?{
        return 44.0
    }
    
    var getSelectedMovieObject: MovieDetails? {
        return movieObj
    }
    
    func getSectionTitle(section: Int) -> String {
        var title = ""
        if  section < sectionNames.count && section >= 0 {
            title = sectionNames[section]
        }
        return title
    }
    
    ///GET FAVOURITES DATA
    private func getFavoritesList() {
        NetworkService.shared.loadFavoritesList{ [weak  self] response in
            switch response {
            case .success(let list):
                self?.favoriteIds =  list.results
                self?.sorteddataFavorites()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    ///GET FAVOURITES FROM RESULT USING IDS
    private func sorteddataFavorites() {
            for element in self.results {
                for value in self.favoriteIds {
                    if element.id == value.id {
                        self.favoritesList.append(element)
                        let index = self.results.firstIndex{ $0.id == element.id} ?? 0
                        self.results.remove(at: index)
                    }
                }
            }
            self.watchedMoview = self.results.filter { $0.isWatched == true  }
            self.toWatchMoview =  self.results.filter { $0.isWatched == false }
            self.watchedMoview.append(contentsOf: self.favoritesList)
            self.toWatchMoview.append(contentsOf: self.favoritesList)
            DispatchQueue.main.async {
                self.reloadTable.value = true
            }
    }
    
    ///Get table items count
    func numberOfItems(section: Int) -> Int {
        if 0 == section {
            return 1
        }
        else if 1 == section {
            return self.watchedMoview.count
        }
        else  {
            return self.toWatchMoview.count
        }
    }
    
    ///Get height for movieslist table
    func getHeightForItem(indexPath: IndexPath) -> CGFloat {
        let heightValue: CGFloat = indexPath.section == 0 ? 140 : 50
        return heightValue
    }
    
 
    ///Get movie list cell data to configure tableviewcell
    func getCellObject(indexPath: IndexPath) ->  tupleVar  {
        var tupleReturnValue = ("","",false)
        switch indexPath.section{
        case 1:
            tupleReturnValue = self.getMovieObject(indexPath: indexPath, movieArray: self.watchedMoview, tupleReturnValue)
        case 2:
            tupleReturnValue = self.getMovieObject(indexPath: indexPath, movieArray: self.toWatchMoview, tupleReturnValue)
        default:
            break
        }
        return tupleReturnValue
    }
    
    ///check for index and get data for uitableviewcell at indexpath
    private  func getMovieObject(indexPath: IndexPath , movieArray: [MovieDetails],_ tuple: tupleVar ) -> tupleVar {
        var tupleValue = tuple
        if   !movieArray.isEmpty && indexPath.row < movieArray.count {
            tupleValue.0 = movieArray[indexPath.row].title
            tupleValue.1 = movieArray[indexPath.row].poster_path
            if movieObj.id == movieArray[indexPath.row].id {
                tupleValue.2 = true
            }
        }
        return tupleValue
    }
}

//MARK :- NETWORK API CALL
extension MovieslistViemodel: NetworkFetcher {
    ///GET MOVIES LIST
    func getMovies() {
        NetworkService.shared.loadMovieesList{ [weak  self] response in
            switch response {
            case .success(let list):
                self?.results = list.results
                self?.results.sort {
                    $0.rating > $1.rating
                }
                self?.getFavoritesList()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

extension MovieslistViemodel: MovieslistViemodelInputProtocol {
    func selectedMovieIndex(_ index: Int, section: Int) {
        switch section{
        case 0:
            movieObj = self.getMovieObject(index, movieArray: self.favoritesList)
        case 1:
            movieObj = self.getMovieObject(index, movieArray: self.watchedMoview)
        case 2:
            movieObj = self.getMovieObject(index, movieArray: self.toWatchMoview)
        default:
            break
        }
        self.reloadTable.value = true
    }
    
    private  func getMovieObject(_ row: Int , movieArray: [MovieDetails] ) -> MovieDetails {
        if   !movieArray.isEmpty && row < movieArray.count {
            movieObj = movieArray[row]
        }
        return movieObj
    }
}

