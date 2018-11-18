//
//  TASampleTests.swift
//  TASampleTests
//
//  Created by Gennadii Tsypenko on 16/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import XCTest
@testable import TASample

class TASampleTests: XCTestCase {
    
    let jsonDecoder = JSONDecoder()
    var getRestaurantsDataModel: GetRestaurantsDataModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testsomeTest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        if let getRestaurantsDataModel = try? jsonDecoder.decode(GetRestaurantsDataModel.self, from: "stub".stubData) {
            XCTAssertNotNil(getRestaurantsDataModel.restaurants, "Response is empty")
            self.getRestaurantsDataModel = getRestaurantsDataModel
            testRestaurantDataModelProperties()
        } else {
            XCTFail("Parsing failed")
        }
        
    }
    
    func testRestaurantDataModelProperties() {
        let firstRestaurantsDataModel = getRestaurantsDataModel.restaurants?.first
        XCTAssert(firstRestaurantsDataModel?.name == "Tanoshii Sushi", "name doesn't match")
        XCTAssert(firstRestaurantsDataModel?.status == "open", "status doesn't match")
        let sortingValues = firstRestaurantsDataModel?.sortingValues
        XCTAssert(sortingValues?.bestMatch == 0.0, "best match doesn't match")
        XCTAssert(sortingValues?.newest == 96.0, "best match doesn't match")
        XCTAssert(sortingValues?.ratingAverage == 4.5, "best match doesn't match")
        XCTAssert(sortingValues?.distance == 1190, "best match doesn't match")
        XCTAssert(sortingValues?.popularity == 17.0, "best match doesn't match")
        XCTAssert(sortingValues?.averageProductPrice == 1536, "best match doesn't match")
        XCTAssert(sortingValues?.deliveryCosts == 200, "best match doesn't match")
        XCTAssert(sortingValues?.minCost == 1000, "best match doesn't match")
        
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
