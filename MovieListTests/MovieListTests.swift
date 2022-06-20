//
//  MovieListTests.swift
//  MovieListTests
//
//  Created by soujanya Balusu on 14/06/22.
//

import XCTest
@testable import MovieList

class MovieListTests: XCTestCase {
    var viewModel: MovieslistViemodel?
    override func setUpWithError() throws {
        viewModel = MovieslistViemodel()

    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNumberOfRows() {
        let numberofRows = viewModel?.output.numberOfItems(section: 0)
        // then
        XCTAssertEqual(numberofRows, 1, "Number of rows should be Three")
    }
    
    func testNumberOfsections() {
        // given
       
        // when
        let numberofSections =  viewModel?.output.sectionNamesCount
        // then
        XCTAssertEqual(numberofSections, 3, "Number of sections should be three")
    }
    
    func testnumberOfItems() {
        let items = viewModel?.numberOfItems(section: 0)
        XCTAssertEqual(items, 1, "Number of items should be zero")
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testgetMoviesData() {
        viewModel?.getMovies()
        XCTAssertEqual(viewModel?.watchedMoview.count, 0, "count of items should be 0")
    }
    
    func testgetHeightForItem(){
      let height =   viewModel?.getHeightForItem(indexPath: [0,0])
        XCTAssertEqual(height, 140, "height is 140")
    }
    
    func testgetHeightForheader() {
        let height =   viewModel?.output.headerHeight ?? 0.0
        XCTAssertEqual(height, 44, "height is 44")
    }
    
    
    
   
}



