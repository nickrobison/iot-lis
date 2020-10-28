//
//  LISManagerTests.swift
//  LISManagerTests
//
//  Created by Nicholas Robison on 10/16/20.
//

import XCTest
import UIKit
@testable import LISManager

class LISManagerTests: XCTestCase {

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
    
    func testImageDetection() throws {
        guard let img = UIImage(named: "SampleUSDSForm") else {
            fatalError("Cannot find image")
        }
        let reader = FormReader()
        
        self.measure {
            let expectation = self.expectation(description: #function)
            var result: String?
            reader.extractText(img) { value in
                result = value
                expectation.fulfill()
            }
            waitForExpectations(timeout: 20)
            XCTAssertNotNil(result)
        }
    }

}
