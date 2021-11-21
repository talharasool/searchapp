//
//  moyaTest.swift
//  searchappTests
//
//  Created by talha on 21/11/2021.
//
import RxSwift
import XCTest
@testable import searchapp

class moyaTest: XCTestCase {

    var networkManager = APIRequest.shared

    override func setUp() {
        super.setUp()
       
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserTotalcount() {
        
        var response: SearchModel?
        let expectation = self.expectation(description: "request")
        networkManager.fetchResult(target: .searchComponents(login: "talharasool", page: 11)) { (model : SearchModel) in
            response = model
            expectation.fulfill()
        } failure: { error in
            XCTFail("did hit an unexpected target")
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertTrue(response!.total_count == 2)
    }
    

}
