//
//  PatientAddTests.swift
//  LISManagerTests
//
//  Created by Nicholas Robison on 10/22/20.
//

import XCTest
import UIKit
@testable import LISManager

class PatientAddTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let model = PatientAddModel()
        model.firstName = "Hello"
        model.lastName = "Nope"
        
        let exp1 = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertFalse(model.isValid)
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 5.0)
        model.gender = "M"
        model.sex = "F"
        model.address1 = "hello"
        model.city = "Wash"
        model.state = "DC"
        model.zipCode = "20008"
        
        let exp2 = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(model.isValid)
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 5.0)
    }
}
