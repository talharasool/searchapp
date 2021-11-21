//
//  viewmodelTest.swift
//  searchappTests
//
//  Created by talha on 21/11/2021.
//

import XCTest
import RxSwift
@testable import searchapp

class viewmodelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    var viewModel : SearchViewModel!
    var disposeBag: DisposeBag!
    
     override func setUp() {
        super.setUp()
        
         viewModel = SearchViewModel()
    }
    
    
    override  func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    
    func testFetchResult(){
        var response: SearchModel!
        viewModel.fetchResult.onNext("talha")
        let expectation = self.expectation(description: "request")
        viewModel.searchData.subscribe {  searchData in
            guard let data = searchData.element else {return}
            response = data
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertTrue(!(response.items.isEmpty))
    }

    
    
}
